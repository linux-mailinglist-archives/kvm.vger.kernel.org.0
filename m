Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C26836AAF8
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 05:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhDZDKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Apr 2021 23:10:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17057 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZDKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Apr 2021 23:10:24 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FT8vR5qqSz17Rb7;
        Mon, 26 Apr 2021 11:07:15 +0800 (CST)
Received: from [10.174.187.192] (10.174.187.192) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 26 Apr 2021 11:09:34 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
Subject: About vcpu scheduling strategy
To:     <will@kernel.org>, Marc Zyngier <maz@kernel.org>
CC:     "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yezengruan@huawei.com" <yezengruan@huawei.com>,
        <kvm@vger.kernel.org>
Message-ID: <79930b9a-b6eb-fd13-5577-9ed25f7e60a5@huawei.com>
Date:   Mon, 26 Apr 2021 11:09:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.192]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc and Will,

We having been working on vcpu scheduling optimization. May I ask is
there any progress or plan on this PV cond yield work?

https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pvcy

Thanks,
Jingyi
