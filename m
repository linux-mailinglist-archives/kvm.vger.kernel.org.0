Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1B01D5B7B
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 23:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEOV3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 17:29:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgEOV26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 17:28:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FLRJuQ182124
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 21:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jt3udJxC8DxjCXxxAtOBmPiJ0URnKQrv+3VVlQVU4tY=;
 b=uaGxZqLzkSllaJl0RrK1N8r8G4Pbj6fq23xK2//KltRt+olz5r5716c+qkQ5i/tAl8Qo
 KSrIbLqB6/wrGeVJN/9j0UXIKdqy+Hhvoy0x83psbZEf/HSozkPsO+vvOFlQg0gOKrxe
 +o638ZZpHsZVOHlkfsVeGgFR/fQiKI0PwVoAjZkF4ozolbZd5J4DoReiaEpT0U23WLmw
 hdygNdJWe+EZwan+uwofmp2UgSyr17JqDYMZJEVSBEs4STuDe2Be3ikZwW+Df8F7RcUU
 zCIUFC7BGqiflYFpIlTfxSS7b4Z4/i1fYxykPaNHyrR+N4QopAED5ITrmuyigD8/+CZc ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 311nu5p22c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 21:28:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FLSB8n141099
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 21:28:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3100ykpca8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 21:28:57 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04FLSufn011184
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 21:28:56 GMT
Received: from [10.154.119.223] (/10.154.119.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 14:28:55 -0700
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: question: KVM_MR_CREATE and kvm_mmu_slot_apply_flags()
Organization: Oracle Corporation
To:     kvm@vger.kernel.org
Message-ID: <7796d7df-9c6b-7f34-6cf4-38607fcfd79b@oracle.com>
Date:   Fri, 15 May 2020 14:28:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=771
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=816 impostorscore=0
 suspectscore=1 spamscore=0 lowpriorityscore=0 cotscore=-2147483648
 bulkscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm investigating optimizing qemu start time for large memory guests,
and I'm trying to understand why kvm_mmu_slot_apply_flags() is called by
kvm_arch_commit_memory_region() for KVM_MR_CREATE.  The comments in
kvm_mmu_slot_apply_flags() imply it should be, but what I've observed is
that the new slot will have no mappings resulting in slot_handle_level_range()
walking the rmaps and doing nothing.  This can take a noticeable amount of
time for very large ranges.  It doesn't look like there would ever be any
mappings in a newly created slot.  Am I missing something?

Thanks,
Anthony
