Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DB52C521D
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgKZKeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 05:34:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727251AbgKZKeW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 05:34:22 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQAX80F086925;
        Thu, 26 Nov 2020 05:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=8goriOFKvIxE4Rq8aYTKlFxSyPqdmuMelaGWqBRdbXU=;
 b=eqzpHxw98+Lhf39/j2pz7bR6m22VSeDyZ9sinR0VHZ1nnwjF+9OeqmFQ3yUGFww8nYg5
 dKkJbVEXWN9IHMHsqDfOnTaZNxECfCNqEekg/VligDgdqN+BAbLLo+z5pBp16S1SPFxN
 boc7yXpFOUSgSdPXvnHaIdmvJoGUNPTmaAZnU5sbHlBU8BfhHoo/QjKyBCM6U8JNGk10
 mG1GMYSdw7MkBT1JjRij6qmIgwYZw6SijKfa5otLtM5MZwQCd/1oGrl2D5U7/O5MtYLZ
 GXMqHduHF5qlhfqh3sWV7CZSJVF8NUhddekyg1ra+wDkAdjL6GBeOoAjoasvbX7QRJsh 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3526k8ev31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 05:34:21 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQAX8Gn087011;
        Thu, 26 Nov 2020 05:34:20 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3526k8ev21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 05:34:20 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQARJFl029993;
        Thu, 26 Nov 2020 10:34:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 351vqqrjtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 10:34:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQAYFYM8520442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 10:34:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 439DDA4057;
        Thu, 26 Nov 2020 10:34:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80037A4040;
        Thu, 26 Nov 2020 10:34:14 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.0.176])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 26 Nov 2020 10:34:14 +0000 (GMT)
Date:   Thu, 26 Nov 2020 11:34:12 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 03/17] 390/vfio-ap: use new AP bus interface to
 search for queue devices
Message-ID: <20201126113412.62c0f42b.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-4-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-4-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_03:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:02 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

A nit: for all other patches the title prefix is  s390/vfio-ap, here you
have 390/vfio-ap.
