Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D1A340D7F
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhCRSqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhCRSqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 14:46:17 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94330C06175F
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 11:46:17 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y27so2031555pga.9
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 11:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bf0Dt0STxVme8E7nNHr9X3FypHJvzfOBAA6p3/VdKOs=;
        b=f4U7f0b0xTtH72mR0AURUneWkNYBzDnPg87aC2lPFJRIjbEVwaeJx1JvRtNRtvS2ib
         nTERXzmVPsbFXSraCX/EG1Cis+s1l4Nn+BiMAIOPcrLjS0HMgr+Rro4OLNbf6eyhiNN6
         1MbcvGkNuV0hUxMD4m/A3DLlfi5YEmRaBLujIL82wZjdgAqrcJNPc9KD+NEW/TXEhOmo
         HK0kXFcpzDREZoawv2//shVPXvrZLKF2nqlgY3gGEJh0IRmF+cZP7lg9BlNSICE2wDlI
         mrQ8VLTnwPAm/PdEUI2TK06Uc1NFVm3i4zxvD0UPtMohF+anAcDwsG0kWakBz/aRQ/Sg
         NRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bf0Dt0STxVme8E7nNHr9X3FypHJvzfOBAA6p3/VdKOs=;
        b=Y7DCUTUekr8QTcpY/UYJjFr2CRHcYBkGR5xtLzqSF4CmDIm/4Qv+4MrAHjKvKEYY69
         FogpIzf8uSC+Aj10gS9jQIKt7h1541H8FrvNfZke4YG0F0dgn78MbVpYe9OEiqCyz2gL
         y4BTVdzmbfPLs9apIRIHw1zdUG8VeVl5OuRk8qMKLJqHzL0KqKOnwEwGiuTUfE00j7IN
         RV9LoILREsx6K1bi4euwkAgYRlAdJKY7qDdmjbfYKl8QWPZjBZtP8JOVkhBy2YbnFszb
         tQ22Yc+W4p2OBBlhkEIbHX/uV4U74RU+JfTdqN/UIRIy7w5XDSf0+S8n2ypC6GHoBG7E
         rFEQ==
X-Gm-Message-State: AOAM5316ktZANPiv3wfegP+LPbJVOtxF4E4dN0nLXg4Jww6hzVLDpJSg
        W52BO8GT/M9VhdmZEoJa0z1rgA==
X-Google-Smtp-Source: ABdhPJwFxywHp7L5YJi90JSdTwq+RSG30E/0m9h/OlAzFFlrxlPlHWRYwoUGnnXZsl5VQFWZec+LCw==
X-Received: by 2002:a65:5543:: with SMTP id t3mr8130155pgr.275.1616093177008;
        Thu, 18 Mar 2021 11:46:17 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c72sm3075133pfb.165.2021.03.18.11.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 11:46:16 -0700 (PDT)
Date:   Thu, 18 Mar 2021 18:46:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/kvm: add get_msr_index_features
Message-ID: <YFOf9Jc3eFw6+dZX@google.com>
References: <20210318145629.486450-1-eesposit@redhat.com>
 <20210318170316.6vah7x2ws4bimmdf@kamzik.brq.redhat.com>
 <c08773f1-4b84-bb19-cda8-c8ac6ffffdaf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c08773f1-4b84-bb19-cda8-c8ac6ffffdaf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021, Paolo Bonzini wrote:
> On 18/03/21 18:03, Andrew Jones wrote:
> > > 
> > >  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> > > +TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
> > 
> > Maybe we should give up trying to keep an alphabetic order.
> 
> FWIW I had fixed that but yeah maybe we should just give up.

Never!  What if we make offenders wear a dunce cap at the next KVM Forum?
