Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1175111FF
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 09:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358564AbiD0HLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 03:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357350AbiD0HLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 03:11:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189892B1B8;
        Wed, 27 Apr 2022 00:07:52 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23R3Xsjw013169;
        Wed, 27 Apr 2022 07:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B67+j3oXFnkiSg6DNRe3WHK5zySHQwpUkwhESGoxCbo=;
 b=kRVTxpgyrde2oL1puFGAToRY0aCW/OxdFYkbSycCoSW2gvafb5tIxY5lgvGz5Vc9kEOF
 eBABtkbul+D66Achobk9TOrPuXJCpzgZxuhSfwUOai2LlFVu9zW3EnHl7BnPcpHOBAol
 VFWjUZ8uht8neRYecPDG4GHwgaOnV6HYdAVYU08GahL1Tp+LzetbG5Ze9Q+fUYdCws1H
 TgztsNJsLetXw2Rm0xzgWId+K59U6wDfI/mxyBEbQqfBc79k/zbxxv6UcwjhNc0Xbfor
 vQjuUQ0uEB+V+y4E4DFqfxipMo7SOxo6C4rDvwGGBrK/L6qdmjg9i4lF8jnSswuxx6rh MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpsspy5ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 07:07:51 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23R6tJOP012846;
        Wed, 27 Apr 2022 07:07:51 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpsspy5tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 07:07:51 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23R72Uv2013217;
        Wed, 27 Apr 2022 07:07:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm938wgkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 07:07:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23R77jcN48365908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 07:07:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD8F842042;
        Wed, 27 Apr 2022 07:07:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 717394203F;
        Wed, 27 Apr 2022 07:07:45 +0000 (GMT)
Received: from [9.145.11.55] (unknown [9.145.11.55])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 07:07:45 +0000 (GMT)
Message-ID: <07c0a131-d695-1c08-e500-94b593203db9@linux.ibm.com>
Date:   Wed, 27 Apr 2022 09:07:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/9] kvm: s390: Add PV dump support
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20220310103112.2156-1-frankja@linux.ibm.com>
In-Reply-To: <20220310103112.2156-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jxELmoLMLNKBgohA32KvE1gGVyvSrCHR
X-Proofpoint-ORIG-GUID: Tl9BbERA6vh2jqKsT20SM3F69hNSA8br
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_02,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=687
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204270047
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/10/22 11:31, Janosch Frank wrote:
> Sometimes dumping inside of a VM fails, is unavailable or doesn't
> yield the required data. For these occasions we dump the VM from the
> outside, writing memory and cpu data to a file.
> 
> Up to now PV guests only supported dumping from the inside of the
> guest through dumpers like KDUMP. A PV guest can be dumped from the
> hypervisor but the data will be stale and / or encrypted.
> 
> To get the actual state of the PV VM we need the help of the
> Ultravisor who safeguards the VM state. New UV calls have been added
> to initialize the dump, dump storage state data, dump cpu data and
> complete the dump process.

Ping
