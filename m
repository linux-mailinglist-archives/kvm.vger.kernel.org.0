Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70289425259
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 13:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbhJGL5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 07:57:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241074AbhJGL5L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 07:57:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197AYSTg004915;
        Thu, 7 Oct 2021 07:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=md8NOqHCtIvYXjQvuJozvlm5okv22YlMuiDBHIfB+uw=;
 b=dFA0/xzJPa8wRD7sIG0oUhvxMh1ezllxcr3Vg76bZHBFECSBDC64OVb/24LHDXxGrEFb
 zLxoVTPCJM/1RNdRF6ZsX8aXJJZ332E+ekYWNDarNvNnSjCpKkCB0r3pWvVvYzTag5Ft
 eByfKmBkaWLG/UEgbgtdXuc8/DMi2gLxif2Gt3nJ7BWvkVWcoTYwc7+SCsgrGLYylegb
 nm0QsUnq7tzor2wGe9Y064i092uE7RIYFtfZXUB7/JvtlIFmIds7X4OBsaCmad9GESXd
 7Vn6nTgLk7OGesSCllII1csPPdhv9lu3MLAJDceO8bsZ5UAghHw5DdV5laTcv5OqrhMu rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhy7q1rur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 07:55:16 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 197AkWEJ023062;
        Thu, 7 Oct 2021 07:55:16 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhy7q1ru2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 07:55:16 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 197BltNj014533;
        Thu, 7 Oct 2021 11:55:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bhepd0evg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 11:55:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 197Bnkvk56688918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 11:49:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C861542052;
        Thu,  7 Oct 2021 11:55:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C258642049;
        Thu,  7 Oct 2021 11:55:09 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.45.119])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  7 Oct 2021 11:55:09 +0000 (GMT)
Date:   Thu, 7 Oct 2021 13:55:07 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 2/2] vfio-ccw: step down as maintainer
Message-ID: <20211007135507.358a5c7f.pasic@linux.ibm.com>
In-Reply-To: <20211006160120.217636-3-cohuck@redhat.com>
References: <20211006160120.217636-1-cohuck@redhat.com>
        <20211006160120.217636-3-cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QG9nn2i3KStMdUtTjJJYszZqHMsKwGh4
X-Proofpoint-ORIG-GUID: AkeULNBZhUWnG5vbLnprlpa6nPZ9MWpy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_01,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxlogscore=841 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  6 Oct 2021 18:01:20 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> I currently don't have time to act as vfio-ccw maintainer
> anymore

Sorry to hear that. Thank you for your valuable work on vfio-ccw!

Regards,
Halil
