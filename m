Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82262783FC
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgIYJ3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:29:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726255AbgIYJ3u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 05:29:50 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P9COZj018692;
        Fri, 25 Sep 2020 05:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NguD6eXwu//VK1apBm8csu5L/BvCEbdbw9lIW1PzOjM=;
 b=ooU7cx63NTZ9Vl/t7hU0pJBjhMzwydhCmhKXKUujpnk61tnA8gpdXHjSqeKpojS/84Zz
 bOlVAaGuf+DKNHvd//9SB3BD/cIDk9UcEOzFJtlY47OweX+LqvBz0OWWJqSbZxrl4a7H
 oMw1BxYWQ6ZOR7Wy+7S5pXrVnPtE52R4gGqtDtcEHzf9dR1rz2ECCkmRZU5/zz8zp4IX
 CTjGPKMXXkur6clekF83rKzjzvE5AYHDxu743TCJbZcR9Pn4P7SduIMwfEYT1jKzDqtt
 oVS+cG1hTK35ui86KpjCT8b395Z0ci43um+pyp+q3o2pJD0mkvstaEoqGqSedzZJkDrh jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33sdq9rf5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 05:29:49 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08P9OEZp059160;
        Fri, 25 Sep 2020 05:29:48 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33sdq9rf53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 05:29:48 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08P9H2ue001502;
        Fri, 25 Sep 2020 09:29:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 33n9m8e47x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 09:29:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08P9Thq627460070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 09:29:43 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA1E311C052;
        Fri, 25 Sep 2020 09:29:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 009B211C05B;
        Fri, 25 Sep 2020 09:29:43 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.53.230])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Sep 2020 09:29:42 +0000 (GMT)
Date:   Fri, 25 Sep 2020 11:29:41 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 05/16] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20200925112941.71589591.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-6-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-6-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_02:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxscore=0 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 mlxlogscore=787 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:05 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> +
> +bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
> +{
> +	bool in_use;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	in_use = !!vfio_ap_mdev_verify_no_sharing(NULL, apm, aqm);
> +	mutex_unlock(&matrix_dev->lock);

See also my comment for patch 4. AFAIU as soon as you release the lock
the in_use may become outdated in any moment.

> +
> +	return in_use;
> +}
