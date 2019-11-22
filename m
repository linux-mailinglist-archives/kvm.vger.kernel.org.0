Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C8A105DD0
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 01:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKVAss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 19:48:48 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7161 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbfKVAss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 19:48:48 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 72CFF34094CB0FA7DA8E;
        Fri, 22 Nov 2019 08:48:45 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 22 Nov 2019
 08:48:39 +0800
Subject: Re: [PATCH -next] KVM: x86: remove set but not used variable 'called'
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <rkrcmar@redhat.com>, <sean.j.christopherson@intel.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20191119030640.25097-1-maowenan@huawei.com>
 <87o8x8gjr5.fsf@vitty.brq.redhat.com> <20191119121423.GB5604@kadam>
 <61f534ca-7575-6716-10ec-ac5c92258452@redhat.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <c4f04d66-ca5c-e55c-777c-5091a099198e@huawei.com>
Date:   Fri, 22 Nov 2019 08:48:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <61f534ca-7575-6716-10ec-ac5c92258452@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

shall we send v2 with fixes tag?

在 2019/11/21 17:13, Paolo Bonzini 写道:
> atch IMHO does.

