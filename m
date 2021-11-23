Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F97145A2D6
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 13:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhKWMnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 07:43:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234712AbhKWMnB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 07:43:01 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANCLSeB038245;
        Tue, 23 Nov 2021 12:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2S6CYgdaO2geucUyM2t2++Aefp6uAeUNROpjjwG5TGo=;
 b=d8gnTo1VjPjSuCJ0qIFVzzSBgdGmIzFCdY/7lQGu7SQUmClkyiBh0aB1Rn8P68PaH9P2
 dHszPBtydKdlZDGzuXuYTm60aFzklVMlpK8qTDCY0Eh8YTQd4g9Izc3An7q4Qu6+i/3d
 mr7tZ4ZMM5HK4OH13J2j4WfXHiXHaT6rMpsU2CgV2fvtrO8f6brtt9nHinJabMaG5kxb
 Zb0EFkD8Dius7Lr7nTGFkgGno0voyQT6FlhwtNwydLDukY7QF8Ev8B7vNGRrtyt9CYxh
 g/AHv1db5pbHmYS0tc1Ncj46rE6hqWXSQbwXEQTpWyI3dFVrWD7/7ZRvgE3C4yWSm6IA vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxun26j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:39:53 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANCLebt039389;
        Tue, 23 Nov 2021 12:39:53 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxun26hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:39:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANCb2nZ014154;
        Tue, 23 Nov 2021 12:39:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3cer9jqwnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:39:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANCdlN462914836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 12:39:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62B81A4054;
        Tue, 23 Nov 2021 12:39:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB628A4064;
        Tue, 23 Nov 2021 12:39:46 +0000 (GMT)
Received: from [9.145.183.32] (unknown [9.145.183.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 12:39:46 +0000 (GMT)
Message-ID: <e15c57b9-f52d-0ca9-ae77-f01fb8c8eab7@linux.ibm.com>
Date:   Tue, 23 Nov 2021 13:39:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/3] KVM: s390: Some gaccess cleanup
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211028135556.1793063-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KT-xTU-pqGnjPaspq3cBA93PZkJ8ul6r
X-Proofpoint-GUID: J1BkGw6hWrMGMsDcaGKTMi61t-TlUnmg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/21 15:55, Janis Schoetterl-Glausch wrote:
> Cleanup s390 guest access code a bit, getting rid of some code
> duplication and improving readability.
> 
> v1 -> v2
> 	separate patch for renamed variable
> 		fragment_len instead of seg
> 	expand comment of guest_range_to_gpas
> 	fix nits
> 
> I did not pick up Janosch's Reviewed-by because of the split patch
> and the changed variable name.
> 
> Janis Schoetterl-Glausch (3):
>    KVM: s390: gaccess: Refactor gpa and length calculation
>    KVM: s390: gaccess: Refactor access address range check
>    KVM: s390: gaccess: Cleanup access to guest frames
> 
>   arch/s390/kvm/gaccess.c | 158 +++++++++++++++++++++++-----------------
>   1 file changed, 92 insertions(+), 66 deletions(-)
> 

Could you please push this to devel so we get some CI coverage?
