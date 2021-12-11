Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF24716B0
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 22:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhLKVUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 16:20:33 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55674 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhLKVUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 16:20:32 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639257631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GAjPHwygExgqdbIcRtHWGI3JoAVDYSeD8WbeunAS0RA=;
        b=jaZZaKIIjSatbNcSr+sPVj3BKhFvSEbrqr2XfwdSLgCL6DN3ANM91VLhGtvhGdISoDb9Md
        OHI7hjUn78px+cW0dU5sphB6iQL0AmiP7nzK0gpr2QZDwt3EhW6JUUhTLtCkO/mtAVEbnr
        yrdXe443X16FCth46Ke2UrG3SfVdTMn37+OsWpDuyTzqvR3k4LcAVluMjGicaxKVYzKGyp
        xbt153o8IHooOwqwtZUMmG9ApebQk9PaIITD4IECC14c0a3XQwOJSZRQs96t1DWAbwZxIS
        X9J3iKvrIU5eKM/CmlI9fmqNeMm209HUnd7jczpkA40cWnFwGEXfZs4rav4Wrg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639257631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GAjPHwygExgqdbIcRtHWGI3JoAVDYSeD8WbeunAS0RA=;
        b=GUc9a8Vyl0I/r34vhzR2hNNR6xxghUJ2zDs5blkMrxk6BlPx+PaFbdt+AtJLeMBLHv8hfS
        JpRMm2AHrfSu11BQ==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 00/19] AMX Support in KVM
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
Date:   Sat, 11 Dec 2021 22:20:30 +0100
Message-ID: <87r1aivnxd.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing, Yang,

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
>
> Thanks Thomas for the thoughts and patches on the KVM FPU and AMX
> support.

welcome. The overall impression of that series is that it is heading
into the right direction. Keep up the good work!

Thanks,

        tglx
