Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DDC42E497
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhJNXLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbhJNXLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893EC061570;
        Thu, 14 Oct 2021 16:09:30 -0700 (PDT)
Message-ID: <20211014225711.615197738@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OkoUtOJd/aTHZHuNnWnOItMShi3nftzEZspViJwU7EM=;
        b=JOPZZogESlhc3o4Yacvp4X5NSplyd5QQXgtEZtU01sLH1Qk5K6ZPQHimgpashJDxt7EmW7
        NrHouuaW2oDXGOYTMoPfnVmSFxiPoYFJ/5BhWDgZnWgf7DCL6ytb8wKlLE2AKPKsi1HwIh
        iyk4nlupzA8w0b9bmsGEv2beFneVeAQxq72FBTPg6h8h2t1mdgriOV6ykrD3lQIaKYh9+e
        BLLkGooCl1jVD1ETK+QWYWoLLTdTP8yNX7TkLo2bdh+wBkaHIYi7eLSYqPEvsl61t4y0WG
        4CiUcWqX3d+PdGPgeOviRAS19gwKuW6TDbwe+qC7fxeA+z+G8zs8noaH3xR3aQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OkoUtOJd/aTHZHuNnWnOItMShi3nftzEZspViJwU7EM=;
        b=LzSKepaH6yWXdGw/ulcToZXR+ucNX43cZ3HjqDaRaE+lJfhNY2qU4SCwTk6GtEaDiCZFun
        CFbgGBPQs+3j8ABQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 0/8] x86/fpu: Consolidate the size and feature information (part 3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Fri, 15 Oct 2021 01:09:28 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhpcyBpcyB0aGUgdGhpcmQgcGFydCBvZiB0aGUgZWZmb3J0IHRvIHN1cHBvcnQgQU1YLiBUaGUg
c2Vjb25kIHBhcnQgY2FuIGJlCmZvdW5kIGhlcmU6CgogICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvMjAyMTEwMTMxNDI4NDcuMTIwMTUzMzgzQGxpbnV0cm9uaXguZGUKCldpdGggQU1YIHRo
ZSBGUFUgcmVnaXN0ZXIgc3RhdGUgYnVmZmVyIHdoaWNoIGlzIHBhcnQgb2YKdGFza19zdHJ1Y3Q6
OnRocmVhZDo6ZnB1IGlzIG5vdCBnb2luZyB0byBiZSBleHRlbmRlZCB1bmNvbmRpdGlvbmFsbHkg
Zm9yCmFsbCB0YXNrcyBvbiBhbiBBTVggZW5hYmxlZCBzeXN0ZW0gYXMgdGhhdCB3b3VsZCB3YXN0
ZSBtaW5pbXVtIDhLIHBlciB0YXNrLgoKQU1YIHByb3ZpZGVzIGEgbWVjaGFuaXNtIHRvIHRyYXAg
b24gZmlyc3QgdXNlLiBUaGF0IHRyYXAgd2lsbCBiZSB1dGlsaXplZAp0byBhbGxvY2F0ZSBhIGxh
cmdlciByZWdpc3RlciBzdGF0ZSBidWZmZXIgd2hlbiB0aGUgdGFzayAocHJvY2VzcykgaGFzCnBl
cm1pc3Npb25zIHRvIHVzZSBpdC4gVGhlIGRlZmF1bHQgYnVmZmVyIHRhc2tfc3RydWN0IHdpbGwg
b25seSBjYXJyeQpzdGF0ZXMgdXAgdG8gQVZYNTEyLgoKVGhpcyBuZWVkcyBtb3JlIGluZm9ybWF0
aW9uIHRoYW4gd2hhdCBpcyBwcm92aWRlZCBub3cgd2l0aCB2YXJpb3VzCnZhcmlhYmxlcy4gCgpU
aGUgb3JpZ2luYWwgYXBwcm9hY2ggd2FzIHRvIGp1c3QgYWRkIG1vcmUgdmFyaWFibGVzLCBidXQg
aXQncyBzaW1wbGVyIHRvCnN0aWNrIHRoaXMgaW50byBkYXRhIHN0cnVjdHVyZXMuIAoKVGhlIGN1
cnJlbnQgc2VyaWVzOgoKIC0gY3JlYXRlcyBhIGRhdGEgc3RydWN0dXJlIHdoaWNoIGNhcnJpZXMg
dGhlIG5lY2Vzc2FyeSBpbmZvcm1hdGlvbjoKICAgZGVmYXVsdCBhbmQgbWF4aW11bSBmZWF0dXJl
cyBhbmQgc2l6ZXMuCgogLSBpbnN0YW50aWF0ZXMgYW5kIGluaXRpYWxpemVzIG9uZSBmb3Iga2Vy
bmVsIGluZm9ybWF0aW9uIGFuZCBvbmUgZm9yIHVzZXIKICAgc3BhY2UKCiAtIGNvbnZlcnRzIGFs
bCB1c2VycyBvZiB0aGUgb2xkIHZhcmlhYmxlcwoKIC0gcmVtb3ZlcyB0aGUgbm93IHVudXNlZCBv
bGQgdmFyaWFibGVzCgpJdCdzIGEgc3RyYWlnaHQgZm9yd2FyZCBjb252ZXJzaW9uIHdoaWNoIHNo
b3VsZCBub3QgaW50cm9kdWNlIGFueQpmdW5jdGlvbmFsIGNoYW5nZXMuCgpUaGlzIHNlcmllcyBp
cyBiYXNlZCBvbjoKCiAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90Z2x4L2RldmVsLmdpdCB4ODYvZnB1LTIKCmFuZCBhbHNvIGF2YWlsYWJsZSBmcm9tIGdp
dDoKCiAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90Z2x4
L2RldmVsLmdpdCB4ODYvZnB1LTMKClRoZSBmdWxsIHNlcmllcyB3aXRoIHBhcnQgNCBvbiB0b3Ag
aXMgYXZhaWxhYmxlIGhlcmU6CgogICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvdGdseC9kZXZlbC5naXQgeDg2L2ZwdQoKVGhhbmtzLAoKCXRnbHgKLS0tCiBp
bmNsdWRlL2FzbS9mcHUvdHlwZXMuaCAgfCAgIDM5ICsrKysrKysrKysKIGluY2x1ZGUvYXNtL2Zw
dS94c3RhdGUuaCB8ICAgNDcgKy0tLS0tLS0tLS0tCiBrZXJuZWwvZnB1L2NvbnRleHQuaCAgICAg
fCAgICA2IC0KIGtlcm5lbC9mcHUvY29yZS5jICAgICAgICB8ICAgMzcgKysrKysrKy0tLQoga2Vy
bmVsL2ZwdS9pbml0LmMgICAgICAgIHwgICA0NiArKysrKy0tLS0tLS0KIGtlcm5lbC9mcHUvaW50
ZXJuYWwuaCAgICB8ICAgIDIgCiBrZXJuZWwvZnB1L3JlZ3NldC5jICAgICAgfCAgICAyIAoga2Vy
bmVsL2ZwdS9zaWduYWwuYyAgICAgIHwgICAxMSArLQoga2VybmVsL2ZwdS94c3RhdGUuYyAgICAg
IHwgIDE3MyArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQog
a2VybmVsL2ZwdS94c3RhdGUuaCAgICAgIHwgICAxNSArKystCiAxMCBmaWxlcyBjaGFuZ2VkLCAy
MDUgaW5zZXJ0aW9ucygrKSwgMTczIGRlbGV0aW9ucygtKQoKCg==
