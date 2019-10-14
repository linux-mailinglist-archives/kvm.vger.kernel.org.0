Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2ABD6A0B
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388523AbfJNTYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:24:38 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:45334 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388245AbfJNTYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:24:38 -0400
Received: by mail-yw1-f73.google.com with SMTP id o204so14335542ywc.12
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 12:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SRhEAAU8/+3Mdz5PZ+SYtqxO9uMOiDzHiECPRjG6fk0=;
        b=l+bq29zH/07IL5UknjGQNzWD1TY5zjol+t1p0ShYvjdH7d+4fPPivIYtOff1EAtXGp
         7fmzgW7frr+we72aiRHaJs9iGeTBKxMEBiM2w8tEiVN5OTjvQvNwCCd3L/V5jS+InitH
         BcO7mMdNVR81necewF4VtF4JNbM2NzsltoqPK20iofZQ1VK9jKtH7FkCit6LQOZSkRcP
         v0L4ORrZTC6vLtVxabJaOhd+qarB2vWatKVLTJC8RPTY4PUT71zgOmPzDRumPp7H6jHL
         Av2P1KGPNmjpYya4aNb2WsxWNdPpPJ1YSuLF2fR+6dDVVWz0KvSAMx19I3PT+KeDLiGl
         yWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SRhEAAU8/+3Mdz5PZ+SYtqxO9uMOiDzHiECPRjG6fk0=;
        b=P/Oe2yXekeLi67sZA2prWF8yrZAfeyUKM8FwKwaSnVunl221oDBVIKjEIQrTFNUQY3
         JcSwo4HCSwbFBJxdDQuyEokm9E0wBqcBd0+quyddM1MW8wLKZCmdeMyL7YEGJJpeVbyo
         GQW2zFVDkAjMoCivrIOyHA03ZNCMwwW3BuqPrFkeS5rbc5sqU7IDjipW4BLIzNDl2oYz
         oWVTrxUqGmRFt/eiSNLlJ1BjqELcFqF58mPjwsgHYw5Ck2dUHGktUlGk4Va3fd50G4Us
         SnY5x7+21KTZDl58GlGEXBfTbsaeNR1uluRRTpOyp3eiLkpurp/j+eXTilJqgpqaZ7+n
         1kgA==
X-Gm-Message-State: APjAAAW54AnB+/0qaOsbZVRkZTiQaBD08/vedJFbQP6s3FQPTInFbZE+
        Q0IgRG+RzGqB4y9X/hG24zGf8s5w4PkHxkatfMPQ7APNXOhNDefRQCJ/B7ncSmx1MYKz16yc08Q
        S4jFarJieDdaBoOAFvkcbEn9cwXHXNRZaC8q15qPwA63keQ5OVoeICw==
X-Google-Smtp-Source: APXvYqw8hW07KX6VM4ejcstU/6myeArsjYb1+/br9/qZMyyAisXytaL6jWrmalGvS9XISoSB0KQP/OBs6w==
X-Received: by 2002:a25:4292:: with SMTP id p140mr20256898yba.47.1571081077283;
 Mon, 14 Oct 2019 12:24:37 -0700 (PDT)
Date:   Mon, 14 Oct 2019 12:24:27 -0700
In-Reply-To: <20191010183506.129921-1-morbo@google.com>
Message-Id: <20191014192431.137719-1-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 0/4] Patches for clang compilation
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These four patches fix compilation issues that clang's encountering.

I ran the tests and there are no regressions with gcc.

Bill Wendling (4):
  x86: emulator: use "SSE2" for the target
  pci: cast the masks to the appropriate size
  Makefile: use "-Werror" in cc-option
  Makefile: add "cxx-option" for C++ builds

 Makefile       | 23 +++++++++++++++--------
 lib/pci.c      |  3 ++-
 x86/emulator.c |  2 +-
 3 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

