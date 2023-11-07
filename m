Return-Path: <kvm+bounces-890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7D47E416E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F1DE1C20C96
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF0230F92;
	Tue,  7 Nov 2023 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8610430F84
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:05:41 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF6CB7
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 06:05:39 -0800 (PST)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SPqfW0q3BzrV1Y;
	Tue,  7 Nov 2023 22:02:27 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 7 Nov 2023 21:54:01 +0800
Subject: Re: [kvm-unit-tests PATCH 1/1] arm64: microbench: Move the read of
 the count register and the ISB operation out of the while loop
To: heqiong <heqiong1557@phytium.com.cn>
CC: <kvm@vger.kernel.org>, <alexandru.elisei@arm.com>, Andrew Jones
	<andrew.jones@linux.dev>
References: <20231107064007.958944-1-heqiong1557@phytium.com.cn>
 <20231107095115.43077-1-heqiong1557@phytium.com.cn>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <70daa5e3-531d-6eb9-cb09-00f0ee9b0687@huawei.com>
Date: Tue, 7 Nov 2023 21:53:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231107095115.43077-1-heqiong1557@phytium.com.cn>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

Hi,

In case that you may have trouble receiving emails from the @linux.dev
addresses (?), please check your inbox again and read the comments that
Drew had replied to your previous versions. You can otherwise read them
on lore, see below.

Zenghui

[1] https://lore.kernel.org/kvm/20231101-923f359769ccf8db69c25c4f@orel
[2] https://lore.kernel.org/kvm/20231107-9b361591b5d43284d4394f8a@orel

