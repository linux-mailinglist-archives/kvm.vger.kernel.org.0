Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E418D87A3
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 06:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbfJPEtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 00:49:53 -0400
Received: from new-01-2.privateemail.com ([198.54.127.55]:16013 "EHLO
        NEW-01-2.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfJPEtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 00:49:53 -0400
Received: from MTA-05-1.privateemail.com (unknown [10.20.147.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by NEW-01.privateemail.com (Postfix) with ESMTPS id C0F8460756
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 04:49:52 +0000 (UTC)
Received: from MTA-05.privateemail.com (localhost [127.0.0.1])
        by MTA-05.privateemail.com (Postfix) with ESMTP id A1DBB6004E
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:49:52 -0400 (EDT)
Received: from zetta.local (unknown [10.20.151.227])
        by MTA-05.privateemail.com (Postfix) with ESMTPA id 69CF36004C
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 04:49:52 +0000 (UTC)
From:   Derek Yerger <derek@djy.llc>
Subject: PROBLEM: Regression of MMU causing guest VM application errors
To:     kvm@vger.kernel.org
Message-ID: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
Date:   Wed, 16 Oct 2019 00:49:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In at least Linux 5.2.7 via Fedora, up to 5.2.18, guest OS applications 
repeatedly crash with segfaults. The problem does not occur on 5.1.16.

System is running Fedora 29 with kernel 5.2.18. Guest OS is Windows 10 with an 
AMD Radeon 540 GPU passthrough. When on 5.2.7 or 5.2.18, specific windows 
applications frequently and repeatedly crash, throwing exceptions in random 
libraries. Going back to 5.1.16, the issue does not occur.

The host system is unaffected by the regression.

Keywords: kvm mmu pci passthrough vfio vfio-pci amdgpu

Possibly related: Unmerged [PATCH] KVM: x86/MMU: Zap all when removing memslot 
if VM has assigned device

Workaround: Use 5.1.16 kernel.

|
|

-- 
Derek Yerger

