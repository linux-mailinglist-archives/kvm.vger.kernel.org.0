Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B52731CBE
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 17:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbjFOPbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 11:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344778AbjFOPbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 11:31:21 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A8926A2;
        Thu, 15 Jun 2023 08:31:08 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C80E71EC0856;
        Thu, 15 Jun 2023 17:31:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1686843066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PBryx5NjZbJSrRf+j6W/ekU/ixeI5U4s1q3ZsejG/w8=;
        b=HEmFhph18JWBnrUpt9EgtnFVmJtwPVicY98S9q2wgUdsCFePKgYiF9GygbC7vC+GcaR/mA
        srxlb7Blf6DF+FLTZ9YZKY8aTpf4x//XOj09pgij6KNw9CqXZjOZiTbZ//S8EJFRCtz1IO
        m8zGy/sMGug6cRzMkw7UjfO6o7adBeI=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id i2vMiVNrNnhs; Thu, 15 Jun 2023 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1686843064; bh=PBryx5NjZbJSrRf+j6W/ekU/ixeI5U4s1q3ZsejG/w8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lNwTg9mDWrL+mjPTsPKaXkpa1g0u5oL2lBYujReWrovObe4F8CbHTawRP3g0ekGBe
         76xw54lSEzCnLPmEIPO3UWAGspal00sS7hnTT+dUfPDZ0XjG9DKxyICkd0pjulyDA4
         iV1jvDosGt4j0ZG4BcnOkri0/ZRFSQ/EBbLClHfyndgc6jUM88L1BSPXn6W7OeL2uu
         qh3kDtTqJgN78U5BZL+tRZjo6GoKJwm0Gc5Sceu5UjhY/pVk3NOy95SEOi/TdlCZ+u
         +RJFRxLJkiRrpQdUu4jKxRXuRs/oTyRSMS37CbI3KQ3M/ipbph5egek4znbwAIzLdA
         8/kG9HNdtK0LhDcOBjfxvqxNScdCW8DEfPYgdgjUat8bUcNHFjehoDpX3r2GKjLq7w
         ef1UxgVwgV2h33vIxSKJ2HoCtP8komGG0SwYpnPlKpcJLRPAJtYAk1pI6IICqhK+h6
         P5f4ea0IXpKogSscMSZjC8Wd2xl8B/73sFE8C8Q+OETxPx1Zw8SymG05YHaGSR7Q5d
         iomQK8lhjNia8ggGv8oTqg8e/DoTmCjABn+5dI4DXNsl61SA0XjtoKVBvUqh5CJonN
         nLoZC3yrW8AlubRRNnK39QAphQHhgVzZJ6iAX3NOv0tp5fyq8oQTIG+Jpadin2Qs3D
         2OKimkRjbOLXbnuhhcOh5rV8=
Received: from zn.tnic (p200300Ea971dC500329c23fffEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c500:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 725B640E018C;
        Thu, 15 Jun 2023 15:30:55 +0000 (UTC)
Date:   Thu, 15 Jun 2023 17:30:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com
Subject: Re: [RFC PATCH v2] x86/sev-es: Include XSS value in GHCB CPUID
 request
Message-ID: <20230615153051.GDZIsuq0qx2GQnO3jV@fat_crate.local>
References: <20230524155619.415961-1-john.allen@amd.com>
 <20230615115255.GBZIr7l2XNKau16ayl@fat_crate.local>
 <ZIss1TJ3ra+dZKOg@johallen-workstation.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZIss1TJ3ra+dZKOg@johallen-workstation.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 10:23:01AM -0500, John Allen wrote:
> How would you advise that I handle this entanglement in the next
> series?

Send the *whole* and complete set to both maintainers - KVM and tip
- and they'll decide how to do the patch tetris.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
