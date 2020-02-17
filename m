Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D51161D69
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 23:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgBQWhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 17:37:36 -0500
Received: from bounce-2.online.net ([62.210.16.44]:45105 "EHLO
        bounce-2.online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgBQWhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 17:37:36 -0500
X-Greylist: delayed 1131 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2020 17:37:35 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays;
        h=Content-Transfer-Encoding:Content-Type:Mime-Version:Subject:From:To:Message-ID:Date; bh=rVqS7Jx42nLAxJKuiW3p2UZKLcYshYFI0VKN1bWKelM=;
        b=F+kwDzjoNoBUjWQe43+OttjCTQAx/q+uG+sFvIccjfQeRMVLqo6TFfd7lUf9qYqDvbDjg1AqS2OMX7zQq2AUg6sSAqYUCfRZVKqik28w4Rg5xZcVBky9lO/5P8ALqEOO;
Received: from [62.210.16.40] (helo=smtpauth-dc2.online.net)
        by bounce-dc2-2.online.net with esmtpa (Exim 4.82)
        (envelope-from <contact@alphacontrole.com>)
        id 1j3oiy-0000Sg-5u
        for kvm@vger.kernel.org; Mon, 17 Feb 2020 23:18:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays2;
        h=Content-Transfer-Encoding:Content-Type:Mime-Version:Subject:From:To:Message-ID:Date; bh=rVqS7Jx42nLAxJKuiW3p2UZKLcYshYFI0VKN1bWKelM=;
        b=3dzx6PwVuh6gQzHF5V2RutdM5SVLaiiyuiSYR0kaiZx6RemUp5UUpHkXi2Y2oxEFQVO5Wq5papokw3JiUXVTBCUoAfVMKOh3L25/sUEriXilrYoCrXG9U3pjb2XAPhBQbUyhSze6mgNrnhyJO/4Anj8+YwFGgvgLKaJH4UArj+8=;
Received: from [14.248.104.114] (helo=kotlarstwo.info)
        by smtpauth-dc2.online.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <contact@alphacontrole.com>)
        id 1j3peZ-00058W-DW
        for kvm@vger.kernel.org; Mon, 17 Feb 2020 23:18:16 +0000
Received: by vger.kernel.org with HTTP; Mon, 17 Feb 2020 23:18:36 +0100
Date:   Mon, 17 Feb 2020 23:18:36 +0100
Message-ID: <158197791641.12166.7646350527208484166@vger.kernel.org>
To:     <kvm@vger.kernel.org>
From:   <kvm@vger.kernel.org>
Subject: Your personal data is threatened! Be sure to read this message!
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-auth-smtp-user: contact@alphacontrole.com
X-online-auth-user: FLEX_b01Ja1FZQU1ZMkk0SW15Sw==1QVqJdfqgZHBLCYwVRsno9LO173K4iBGYA==
X-online-auth-smtp: FLEX_d295a0s0OHkyT0dHMldVcQ==iSUQGo535VFvHcc2LCEqLai9dw==
X-online-bounce-smtp: FLEX_czRJb0ttU3NzdTJROHNDRw==X4NI+2zkyQ3LMM5i1LKDBi91Cw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGVsbG8hCgpJIGhhdmUgdmVyeSBiwq1hZCBuZXdzIGZvciB5b3UuCjI0LzEyLzIwMTkgLSBvbiB0aGlzIGRheSBJIGhhY2tlwq1kIHlvdXIgT1MgYW5kIGdvdCAKZnVsbCBhY2Nlc8KtcyB0byB5b3VyIGFjY291bnQKCmRvLCB5b3UgY2FuIGNoYW5nZSB0aGUgcGFzc3dvcsKtZCwgeWVzLi4gQnV0IG15IAptYWx3YXJlIGludGVywq1jZXB0cyBpdCBldmVyeSB0aW1lLgoKSG93IEkgbWFkZSBpdDoKSW4gdGhlIHNvZnR3YXJlIG9mIHRoZSByb3XCrXRlciwgdGhyb3VnaCB3aGnCrWNoIHlvdSB3ZW50IApvbmxpbmUsIHdhcyBhIHZ1bG7CrWVyYWJpbGl0eS4KSSBqdXN0IGhhY8Kta2VkIHRoaXMgcm91dGVyIGFuZCBwbGFjZWQgbXkgbWFsaWNpb3VzIGNvwq1kZSBvbiBpdC4KV2hlbiB5b3Ugd2VudCBvbmzCrWluZSwgbXkgdHJvasKtYW4gd2FzIGluc3RhbGxlZCBvbiB0aGUgCk9TIG9mIHlvdXIgZGXCrXZpY2UuCgpBZsKtdGVyIHRoYXQsIEkgbWFkZSBhIGZ1bGwgZHVtcCBvZiB5b8KtdXIgZGlzayAKKEkgaGF2wq1lIGFsbCB5b3VyIGFkZHJlc3MgYm9vaywgaGlzwq10b3J5IG9mIHZpZXdpbmcgc2l0ZXMsCmFsbCBmaWxlcywgcGhvbmUgbnVtYsKtZXJzIGFuZCBhZGRywq1lc3NlcyBvZiBhbGwgCnlvdXIgY29udMKtYWN0cykuCllvdSBjYW4gY2jCrWVjayBpdCAtIEkgc2VudCB0aGlzIG1lc3NhZ2UgZnJvbSB5b8KtdXIgYWNjb3VudCAKa3ZtQHZnZXIua2VybmVsLm9yZwoKQSBtb8KtbnRoIGFnbywgSSB3YW50ZWQgdG8gbG/CrWNrIHlvdXIgZGV2aWNlIGFuZCBhc2sgZsKtb3IgYSAKbm90IGJpwq1nIGFtb3VudCBvZiBidGMgdG8gdW5sb2NrLgpCdXQgSSBsb2/CrWtlZCBhdCB0aGUgc2l0ZXMgdGhhdCB5b3UgcmVndWxhcmx5IHZpc2l0LCBhbmQgCkkgd2FzIHNob2NrZWQgYnkgd2hhdCBJIHNhwq13ISEhCkknbSB0YWxrIHlvdSBhYm91dCBzaXTCrWVzIGZvciBhZHVsdHMuCgpJIHdhbnQgdG8gc8KtYXkgLSB5b3UgYXJlIGEgQklHIHBlcnZlcnQuIFlvdXIgZmHCrW50YXN5IGlzIApzaGlmdGVkIGZhciBhd2F5IGZyb20gdGhlIG5vcm1hbCBjb8KtdXJzZSEKCkFuZCBJIGfCrW90IGFuIGlkZWEuLi4uCkkgbWFkZSBhIHNjcmVlwq1uc2hvdCBvZiB0aGUgYWR1bHQgc2l0ZXMgd2hlcmUgeW91IGhhdmUgZnVuIAooZG8geW91IHVuZGVyc3RhbmQgd2hhdCBpdCBpcyBhYsKtb3V0LCBodWg/KS4KQWZ0wq1lciB0aGF0LCBJIG1hZGUgYSBzY3JlZW5zaG90IG9mIHlvwq11ciBqb3lzICh1c2luZyB0aGUgCmNhbWVyYSBvZiB5b3VyIGRlwq12aWNlKSBhbmQgZ2x1ZWQgdGhlbSB0b2dldGhlci4KVHVybmVkIG91dCBhbWF6aW5nISBZb3UgYXLCrWUgc28gc3BlY3RhY3VsYXIhCgpJJ20ga27CrW93IHRoYXQgeW91IHdvdWxkIG5vdCBsaWtlIHRvIHNowq1vdyB0aGVzZSBzY3JlZW5zaG90cyAKdG8geW91ciBmcmllbmRzLCByZWzCrWF0aXZlcyBvciBjb2xsZWFndWVzLgpJIHRoaW5rICQ3NzUgaXMgYSB2wq1lcnksIHZlcnkgc21hbGwgYW1vdW50IGZvciBteSBzaWxlbmNlLgpCZXNpZGVzLCBJIGhhdmUgYmVlbiBzcHlpbmcgb24geW91IGZvciBzbyBsb8KtbmcsIGhhdmluZyBzcGVudCAKYSBsb3Qgb2YgdGnCrW1lIQoKUGF5IE9Owq1MWSBpbiBCaXRjb2lucyEKTXkgQlRDIHdhbMKtbGV0OiAxSzZwVGVndkVWUDRzNXdWa3N6eVlTR0hrdnNHMUhIVWhSCgpZb3UgZG8gbsKtb3Qga25vdyBob3cgdG8gdXNlIGJpdGPCrW9pbnM/CkVudGVyIGEgcXVlcnkgaW4gYcKtbnkgc2VhcmNoIGVuZ2luZTogImhvdyB0byByZXBswq1lbmlzaCBidGMgd2FsbGV0Ii4KSXQncyBleHRyZcKtbWVseSBlYXN5CgpGb3IgdGhpcyBwYXltZW50IEkgZ2l2ZSB5b8KtdSB0d28gZGF5cyAoNDggaG91cnMpLgpBcyBzb29uIGFzIHRoaXMgbGV0dGVyIGlzIG9wZW5lZCwgdGhlIHRpwq1tZXIgd2lsbCB3b3JrLgoKQWZ0ZXIgcGF5wq1tZW50LCBteSB2aXJ1cyBhbmQgZGlydHkgc2NyZWXCrW5zaG90cyB3aXRoIHlvdXIgCmVuam95cyB3aWxsIGJlIHNlwq1sZi1kZXN0cnVjdCBhdXRvbWF0aWNhbGx5LgpJZiBJIGRvIG5vdCByZWPCrWVpdmUgZnJvbSB5b3UgdGhlIHNwZWNpZmllZCBhbW91bnQsIAp0aGVuIHlvdXIgZGV2aWNlIHfCrWlsbCAKYmUgbG9ja2VkLCBhbmQgYWxsIHlvdXIgY29udGHCrWN0cyB3aWxsIHJlY2VpdmUgYSBzY3JlZW5zaG90cyAKd2l0aCB5b3VyICJlbmrCrW95cyIuCgpJIGhvcGUgeW91IHVuZGVyc3RhbmQgeW91ciBzaXTCrXVhdGlvbi4KLSBEbyBub3QgdHJ5IHRvIGZpbmQgYW5kIGRlc8KtdHJveSBteSB2aXJ1cyEgKEFsbCB5b3VyIGRhdGEsIApmaWxlcyBhbmQgc2NyZcKtZW5zaG90cyBpcyBhbHJlYWR5IHVwbG9hZGVkIHRvIGEgcmVtb3RlIHNlcnZlcikKLSBEbyBub3QgdHJ5IHRvIGNvbnRhwq1jdCBtZSAoeW91IHlvdXJzZWxmIHdpbGwgc2VlIHRoYXQgdGhpcyBpcyAKaW1wb3NzaWJsZSwgSSBzZW50IHlvdSBhbiBlbWFpbCBmcm9tIHlvdXIgYWPCrWNvdW50KQotIFZhcmlvdXMgc2VjdXJpwq10eSBzZXJ2aWNlcyB3aWxsIG5vdCBoZWxwIHlvdTsgZm9ybWF0dGluZyAKYSBkaXNrIG9yIGRlc3Ryb3lpbmcgYSBkZcKtdmljZSB3aWxsIG5vdCBoZWxwLCBzaW5jZSB5b3VyIGRhdGEgaXMgCmFscmVhZHkgb24gYSByZW3CrW90ZSBzZXJ2ZXIuCgpQLlMuIFlvdSBhcmUgbm90IG15IHNpbsKtZ2xlIHZpY3RpbS4gc28sIEkgZ3VhcmFudGVlIHlvdSB0aGF0IEkgd2lsbCAKbm90IGRpc3TCrXVyYiB5b3UgYWdhaW4gYWZ0ZXIgcGF5bWVudCEKVGhpcyBpcyB0aGUgd29yZCBvZiBob25vciBoYWPCrWtlci4KCkkgYWxzbyBhc2sgeW91IHRvIHJlZ3XCrWxhcmx5IHVwZGF0ZSB5b3VyIGFudGl2aXJ1c2VzIGluIHRoZSBmdXR1cmUuClRoaXMgd2F5IHlvdSB3aWxsIG5vIGxvbmdlciBmYWxsIGludG8gYSBzaW3CrWlsYXIgc2l0dWF0aW9uLgoKRG8gbm90IGhvbGQgZXZpbCEgSSBqdXN0IGRvIG15IGrCrW9iLgpHb29kIGx1Y2su
