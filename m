Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CE01FDC6
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 04:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEPCnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 22:43:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8201 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbfEPCnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 22:43:15 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0D01E583B023829992BA;
        Thu, 16 May 2019 10:43:13 +0800 (CST)
Received: from [127.0.0.1] (10.177.249.165) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 May 2019
 10:43:05 +0800
From:   "wencongyang (A)" <wencongyang2@huawei.com>
Subject: Question about MDS mitigation
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     Huangzhichao <huangzhichao@huawei.com>,
        guijianfeng <guijianfeng@huawei.com>,
        gaowanlong <gaowanlong@huawei.com>,
        "Chentao (Boby)" <boby.chen@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Message-ID: <f513e534-2c7b-f32b-7346-1a64edf0db73@huawei.com>
Date:   Thu, 16 May 2019 10:42:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.249.165]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all

Fill buffers, load ports are shared between threads on the same physical core.
We need to run more than one vm on the same physical core.
Is there any complete mitigation for environments utilizing SMT?

