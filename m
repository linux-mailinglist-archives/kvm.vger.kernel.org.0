Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252D54D12FD
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 10:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345133AbiCHJEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 04:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiCHJEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 04:04:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1563CA4F;
        Tue,  8 Mar 2022 01:03:11 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2286o7NU031477;
        Tue, 8 Mar 2022 09:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jhzbD9JsghYPcWyAD0qVKklr8/WA9pytd1XN5c2eruQ=;
 b=TVXtyA5WWXNgyLbr7Z7r1pjlPrbH31L8UEHeOb/IWIXoA+6A+aG/SDl+56MBt2fPgNps
 M7CPq3WmLTZzen00X7QRStUK9WeHWjhvpBVDAP/hHGWdkJMvUI2bcGHDkAfZVXalHfYf
 mvZaqDj4C+2tNsX8s80YmpKKHyEQcCpGqU2S10Qzm/Ee7370G1uCxTyFtC030pSum0hg
 r2OFdVEzXGp0K39SHDK64iSNKYxdXkJS71c/NoBrsDp1paK8SOPScZ8wKoJtGm68tz6K
 I+GCHE1w94vHpnNnhWz8wDdUlP2+oSs5yikikpkZu4BKuoGHD7dcgHmSupdMVtguiAnA 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eny1863cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 09:03:11 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2288jUuw015727;
        Tue, 8 Mar 2022 09:03:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eny1863bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 09:03:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2288voRs005794;
        Tue, 8 Mar 2022 09:03:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3enqgnhjnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 09:03:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228935ni53084562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 09:03:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A405A405B;
        Tue,  8 Mar 2022 09:03:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4E6FA405F;
        Tue,  8 Mar 2022 09:03:04 +0000 (GMT)
Received: from [9.145.44.47] (unknown [9.145.44.47])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Mar 2022 09:03:04 +0000 (GMT)
Message-ID: <c3d36f1b-ed45-a188-15b6-83626355bf24@linux.ibm.com>
Date:   Tue, 8 Mar 2022 10:03:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220303210425.1693486-1-farman@linux.ibm.com>
 <20220303210425.1693486-7-farman@linux.ibm.com>
 <1aa3b683-061d-465a-89fa-2c748719564d@linux.ibm.com>
 <4d7026348507cd51188f0fc6300e7052d99b3747.camel@linux.ibm.com>
 <500af9df424ebe51e513e167b6ae39dabb4b1378.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 6/6] lib: s390x: smp: Convert remaining
 smp_sigp to _retry
In-Reply-To: <500af9df424ebe51e513e167b6ae39dabb4b1378.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1FeCI2W3qjqPwt7iT3Xsr1vOpWhXS303
X-Proofpoint-ORIG-GUID: mzz8j3mYWOE2kLESNXi-L7P0SQ-9noEN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/22 21:15, Eric Farman wrote:
> On Mon, 2022-03-07 at 15:42 +0100, Nico Boehr wrote:
>> On Fri, 2022-03-04 at 11:56 +0100, Janosch Frank wrote:
>>> On 3/3/22 22:04, Eric Farman wrote:
>>>> A SIGP SENSE is used to determine if a CPU is stopped or
>>>> operating,
>>>> and thus has a vested interest in ensuring it received a CC0 or
>>>> CC1,
>>>> instead of a CC2 (BUSY). But, any order could receive a CC2
>>>> response,
>>>> and is probably ill-equipped to respond to it.
>>>
>>> sigp sense running status doesn't return a cc2, only sigp sense
>>> does
>>> afaik.
>>> Looking at the KVM implementation tells me that it's not doing more
>>> than
>>> looking at the R bit in the sblk.
>>
>>  From the POP I read _all_ orders may indeed return CC=2: case 1 under
>> "Conditions precluding Interpretation of the Order Code".
>>
>> That being said, there are a few more users of smp_sigp (no retry) in
>> smp.c (the test, not the lib).
>>
>> Does it make sense to fix them aswell?
> 
> I thought it made sense to do the lib, since other places expect those
> things to "just work."
> 
> But for the tests themselves, I struggle to convince myself with one
> path over another. The only way KVM returns a CC2 is because of a
> concurrent STOP/RESTART, which isn't a possibility because of the
> waiting the lib itself does when invoking the STOP/RESTART. So should
> the tests be looking for an unexpected CC2? Or just loop when they
> occur? If the latter, shouldn't the lib itself do that?
> 
> I'm happy to make changes, I just can't decide which it should be. Any
> opinions?

Before we continue bikeshedding, let's add the cc2 retry. If it never 
returns cc2 we'll never loop on it but the dead code won't kill us either.
