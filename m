Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8932C76E4
	for <lists+kvm@lfdr.de>; Sun, 29 Nov 2020 01:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgK2Arc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 19:47:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725616AbgK2Arc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 28 Nov 2020 19:47:32 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AT0VkVw140026;
        Sat, 28 Nov 2020 19:46:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AEu2YDydB/SF+5DWd+uZHgYYz+P4E6JaKj4SF/AC3wY=;
 b=skVlZ8XtkXrvNgkj+OHqyrwev2g3q72g3qx7TRbwSc3i75f3RCs+SjWNsxiUqztkzho4
 zkAtJa/kt6roUSUXxKQdO4jHdTnpPq2KUHMp9n0vLxP1o6o934JNq39ZmwhW+pHzvZV0
 z2f6vCYNacmZTEGfVqiHemBzEGWjFIK/JC8irVTwjd8zgEbkIibA4Jm+4Wb5y3aQlS3B
 fvftEVaBorz6oj+/fCYb4lUIxsLf3ri9FF0ttIXETM5JiBsDhWCDMQT4npeiv+BFzV0/
 iiPputhAj52/wXdbJxXNBsE17n9nYw1PxLIHQAaz52oqOoXiIyZ9/W5fsBUpifV/8gpr Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 353ybf1tw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 19:46:49 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AT0VpVV140112;
        Sat, 28 Nov 2020 19:46:49 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 353ybf1tw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Nov 2020 19:46:48 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AT0WS33008777;
        Sun, 29 Nov 2020 00:46:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 353e6813yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Nov 2020 00:46:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AT0iDol58524014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Nov 2020 00:44:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C80504C04E;
        Sun, 29 Nov 2020 00:44:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 185774C04A;
        Sun, 29 Nov 2020 00:44:13 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.47.217])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 29 Nov 2020 00:44:13 +0000 (GMT)
Date:   Sun, 29 Nov 2020 01:44:11 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 08/17] s390/vfio-ap: introduce shadow APCB
Message-ID: <20201129014411.19b24ee8.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-9-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-9-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-28_18:2020-11-26,2020-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011280156
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:07 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The APCB is a field within the CRYCB that provides the AP configuration
> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
> maintain it for the lifespan of the guest.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Still LGTM
