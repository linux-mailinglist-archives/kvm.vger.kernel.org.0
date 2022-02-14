Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2408B4B4327
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbiBNH7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:59:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiBNH7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:59:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211BE5B3D5;
        Sun, 13 Feb 2022 23:59:38 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21E7aJUN020451;
        Mon, 14 Feb 2022 07:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+bALTIQ+fr1Rx10i1+cPldXe4c7o64whp2bxE8/2sFM=;
 b=rsj3uFNXw7x12zJHgoYA21sX/lfB7dTk0kPqqAB5gkVQKyGFjdHAkSBo4o4Jx035j48P
 WftuK6M1afxC4O3UNJMJrEWVJS95URrs5d/hKUPK599jos/kP3Nmg5NpTUVcOruGwQSm
 S1oRqnjj37Q2me6mSH82AkKoJ4SrY9q3z18n8TjogdkRfpUqU9qkcpkXFJ9ax7+zfjwx
 tj3XhO3j4OKn2AsnlSbO7P3rbMBeVX3WxxeL7/ApmruDzCFa/YSN8+ScLPUynw4Lt4p0
 zhJx4gHCdE0pT8ud3GktqtUWGw/NcAEEUCvs3QWnjhjGSFNcXBE3pNvFvahCki09B6/+ XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7d0jemsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 07:59:37 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21E6jMqO010288;
        Mon, 14 Feb 2022 07:59:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7d0jemrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 07:59:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21E7jkp1024642;
        Mon, 14 Feb 2022 07:59:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64h9jm7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 07:59:33 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21E7xUJ945744552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 07:59:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BE93A4065;
        Mon, 14 Feb 2022 07:59:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE7D3A4064;
        Mon, 14 Feb 2022 07:59:29 +0000 (GMT)
Received: from [9.171.42.254] (unknown [9.171.42.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 07:59:29 +0000 (GMT)
Message-ID: <f33923e1-5032-9ffb-5178-a8e91511d4aa@linux.ibm.com>
Date:   Mon, 14 Feb 2022 09:01:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
 <20220208132709.48291-3-pmorel@linux.ibm.com>
 <62c23e3a-8cc9-2072-6022-cb23dfa08ce7@linux.ibm.com>
 <be515acc30a69e5cbf2f01828685844b7beb0856.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <be515acc30a69e5cbf2f01828685844b7beb0856.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pwsi_y0uSHYCVa3aEu27tS3Hl1ciaX7E
X-Proofpoint-GUID: PFzK_jiaBZGrJ6OG9QB3jhLYPKFhPADm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_01,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140046
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/22 16:43, Nico Boehr wrote:
> On Tue, 2022-02-08 at 16:31 +0100, Janosch Frank wrote:
>>> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
>>> new file mode 100644
>>> index 00000000..9b40664f
>>> --- /dev/null
>>> +++ b/lib/s390x/stsi.h
>>> @@ -0,0 +1,32 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>>> +/*
>>> + * Structures used to Store System Information
>>> + *
>>> + * Copyright IBM Corp. 2022
>>> + */
>>> +
>>> +#ifndef _S390X_STSI_H_
>>> +#define _S390X_STSI_H_
>>> +
>>> +struct sysinfo_3_2_2 {
>>
>> Any particular reason why you renamed this?
> 
> Stumbled across this as well. I think this makes it consistent with
> Linux' arch/s390/include/asm/sysinfo.h.
> 
> The PoP, on the other hand, calls it SYSIB, so this at least resolves
> the inconsistency between kvm-unit-tests and Linux.
> 

In fact I do not know why I renamed it probably because I coded the next 
patches first and used sysinfo in it.
QEMU calls these structures SysIB so for me we do as you want.

-- 
Pierre Morel
IBM Lab Boeblingen
