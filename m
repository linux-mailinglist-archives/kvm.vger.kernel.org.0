Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE48C16BD4F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 10:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgBYJbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 04:31:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727114AbgBYJbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 04:31:19 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 96D11FC650D6C602D14C;
        Tue, 25 Feb 2020 17:31:17 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Feb 2020
 17:31:06 +0800
To:     <gregkh@linuxfoundation.org>, <gleb@kernel.org>,
        <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <yangerkun@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Subject: [Question] fix about CVE-2018-12207 for linux-4.4.y
Message-ID: <26d70537-48a6-8c50-a496-acb1b20e8dd0@huawei.com>
Date:   Tue, 25 Feb 2020 17:31:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I have notice that the status of CVE-2018-12207 for linux-4.4.y stay 
vulnerable for a long time(linux-4.9.y has fix it, and I have try to fix 
it, but the different of kvm between linux-4.4.y and linux-4.9.y make it 
hard to do this). So I wander does there some plan to fix it in linux-4.4.y?

Thanks,
Kun.

