Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB40FD073C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfJIGbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 02:31:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50217 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfJIGbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 02:31:11 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iI5V1-0006HU-Nf; Wed, 09 Oct 2019 08:31:03 +0200
Date:   Wed, 9 Oct 2019 08:31:03 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [Patch 2/6] KVM: VMX: Use wrmsr for switching between guest and
 host IA32_XSS
Message-ID: <20191009063103.abkfrq4anlgixa7y@linutronix.de>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191009004142.225377-2-aaronlewis@google.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-10-08 17:41:38 [-0700], Aaron Lewis wrote:
> Set IA32_XSS for the guest and host during VM Enter and VM Exit
> transitions rather than by using the MSR-load areas.

Could you please explain the *why* as part of the message?

> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

Sebastian
