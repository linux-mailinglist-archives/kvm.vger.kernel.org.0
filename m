Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619C123D1A7
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 22:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHEUEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 16:04:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8769 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728337AbgHEUEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 16:04:46 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 42C43697C4BC60F81D39;
        Wed,  5 Aug 2020 19:55:01 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 5 Aug 2020
 19:54:52 +0800
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <maz@kernel.org>,
        <eric.auger@redhat.com>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
Date:   Wed, 5 Aug 2020 19:54:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200731074244.20432-1-wangjingyi11@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Currently, kvm-unit-tests only support GICv3 vLPI injection. May I ask
is there any plan or suggestion on constructing irq bypass mechanism
to test vLPI direct injection in kvm-unit-tests?

Thanks，
Jingyi

