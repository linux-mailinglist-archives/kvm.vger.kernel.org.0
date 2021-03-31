Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A6034FAA9
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 09:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhCaHpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 03:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234224AbhCaHoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 03:44:44 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB5DC061574;
        Wed, 31 Mar 2021 00:44:44 -0700 (PDT)
Received: from [10.164.192.140] (dynamic-002-247-240-140.2.247.pool.telefonica.de [2.247.240.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CF60E1EC0512;
        Wed, 31 Mar 2021 09:44:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617176683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0sjup1HhLFjq9eGLjnKOtMxmpb/aQzFdHA8EPf63HQ=;
        b=N0uYgy88Cx/7tovViP1CjiDB/FlFv1/1Rb3DW6kLjSwpHPaKP7NS/qRGaHHmBZ/gfFt3oL
        d6MfYmOlMzpQR8fMqiKphXc+5swr2F3/ZwdLJEbnN3eRQLLRk2xAMcv4o6pztt0MMtMSRy
        ahvXFAKewT2jvjkOvm2Vu4CxReIATGk=
Date:   Wed, 31 Mar 2021 09:44:39 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210331195138.2af97ec1bb4b5e4202f2600d@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com> <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com> <20210326150320.GF25229@zn.tnic> <20210331141032.db59586da8ba2cccf7b46f77@intel.com> <D4ECF8D3-C483-4E75-AD41-2CEFDF56B12D@alien8.de> <20210331195138.2af97ec1bb4b5e4202f2600d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM guests
To:     Kai Huang <kai.huang@intel.com>
CC:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
From:   Boris Petkov <bp@alien8.de>
Message-ID: <3889C4C6-48E2-4C97-A074-180EB18BDA29@alien8.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On March 31, 2021 8:51:38 AM GMT+02:00, Kai Huang <kai=2Ehuang@intel=2Ecom>=
 wrote:
>How about adding explanation to Documentation/x86/sgx=2Erst?

Sure, and then we should point users at it=2E The thing is also indexed by=
 search engines so hopefully people will find it=2E

Thx=2E

--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
