Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974FF3161EA
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 10:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBJJRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 04:17:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:43858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhBJJN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 04:13:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612948389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mzj42rQoza7fGjZg+QG+8Ce74Zcx2Zp6oD99wVEENFg=;
        b=CfO+ZjUEVoMsf1rL4OZP8K8Hs8rTqAtfnnXNnlhUep8udX3eEAmZJOg//RKDQT2mzg6wHS
        BTXm7LXdzuk0uTJ5H2KTy8Rb+j9MI7+5JKkiIPAVjG+HZQRq2AUwsEv558nRAvVAt1XWA8
        Plogb+APFMd64oA2sisKB6CY7kVttqM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7EB25AF2A;
        Wed, 10 Feb 2021 09:13:09 +0000 (UTC)
To:     Jonny Barker <jonny@jonnybarker.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     KVM <kvm@vger.kernel.org>
From:   Jan Beulich <jbeulich@suse.com>
Subject: your patch "KVM: x86: Update emulator context mode if SYSENTER xfers
 to 64-bit mode"
Message-ID: <6032a7c3-94d3-0d53-4c94-4767b5a9d6c3@suse.com>
Date:   Wed, 10 Feb 2021 10:13:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've noticed this patch while routinely screening the stable
kernel logs for issues we may also need to fix in Xen. Isn't
a similar change needed in SYSCALL emulation when going from
compat to 64-bit mode?

Jan
