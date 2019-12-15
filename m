Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C511F712
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2019 10:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfLOJyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Dec 2019 04:54:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50973 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726050AbfLOJyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Dec 2019 04:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576403691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1f/gy7GAu+tVHMgArCL2bMPC9tQyMSsCzhr+i5i4NQ=;
        b=OpiUVlW0SOFVvdOGog4Gi4pFiJ0uCfxvDZ2F9lLxVrnpx93GybXD2ne/tWR8mqYIVS6qUF
        KBPaWGP/ZByu4phZunNcEu5ziAHn1yHcnBAtXkVWuF/IvDiCvRVoS+FVVf99VodLFnsxBm
        ugY12aKXxmFmS6Dd6hP6t0BWxGumRks=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-mzTujXHFOx6TnyOmrF4umQ-1; Sun, 15 Dec 2019 04:54:49 -0500
X-MC-Unique: mzTujXHFOx6TnyOmrF4umQ-1
Received: by mail-qk1-f199.google.com with SMTP id 24so2593003qka.16
        for <kvm@vger.kernel.org>; Sun, 15 Dec 2019 01:54:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=T1f/gy7GAu+tVHMgArCL2bMPC9tQyMSsCzhr+i5i4NQ=;
        b=Mo7KFqosMoqTrG+tVxUF8BL9pIUwp/H1JDKDezs4UDqhgdQnOpNoeWQdXv/C3PKkpr
         fCNELJVo3HoRDfF4mwk8Y0PSLmsQzyDjFVNJinl5Z8exadVMZjdGSRp80yS6ENsl5TLZ
         8sZ6D89XVPRMlV1TjNv7V+y6l+Wb5yaqrv9kdMNBC8fFhZSZpvDot0y4EZBHCiXllV5f
         iztaGDSjsLVs64D6Kd7a+tDpfw+Qcjjcp7BYyVB0VEz0N1IPSOcFBEi1HJZUNdGbaR2j
         wH59YRPbk+qFleFHXO5efs/mZYNn9Lms2hQgVsvss6XLniWQ5YQFfm+d5dzLWjKreRGC
         HlCg==
X-Gm-Message-State: APjAAAXi37OxxBXyxLxxCNzo8Fmfz6T1RBFILqWNZM5JxR6HnO9Wuyq8
        Uqwvo5QR+ajpsI+Ud7wIzyMp+0zV7Y4O90+ZuhaqkZcX8i5EKIgjpHe4e46Lmqkl4uBc9KK4Vrr
        a5aeF1URNp6Cx
X-Received: by 2002:a37:a98e:: with SMTP id s136mr22239264qke.253.1576403689152;
        Sun, 15 Dec 2019 01:54:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwBjQGeI+OUxK2u+rGe7U2c1Ycf3YvIBLfP1X5FXOC3InLvwFd942CELbUy2R722482FVQ3BQ==
X-Received: by 2002:a37:a98e:: with SMTP id s136mr22239245qke.253.1576403688946;
        Sun, 15 Dec 2019 01:54:48 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id n7sm4780899qke.121.2019.12.15.01.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 01:54:48 -0800 (PST)
Date:   Sun, 15 Dec 2019 04:54:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm <qemu-arm@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/8] Simplify memory_region_add_subregion_overlap(...,
 priority=0)
Message-ID: <20191215045230-mutt-send-email-mst@kernel.org>
References: <20191214155614.19004-1-philmd@redhat.com>
 <CAFEAcA_QZtU9X4fxZk2oWAkN-zxXdQZejrSKZbDxPKLMwdFWgw@mail.gmail.com>
 <31acb07b-a61b-1bc4-ee6e-faa511745a61@redhat.com>
 <CAFEAcA-UdDF2pd24NoOqpXSTnHHFWdvcexi5bRzq6ewt5vrrWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA-UdDF2pd24NoOqpXSTnHHFWdvcexi5bRzq6ewt5vrrWQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 14, 2019 at 08:01:46PM +0000, Peter Maydell wrote:
> On Sat, 14 Dec 2019 at 18:17, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> > Maybe we can a warning if priority=0, to force board designers to use
> > explicit priority (explicit overlap).
> 
> Priority 0 is fine, it's just one of the possible positive and
> negative values. I think what ideally we would complain about
> is where we see an overlap and both the regions involved
> have the same priority value, because in that case which
> one the guest sees is implicitly dependent on (I think) which
> order the subregions were added, which is fragile if we move
> code around. I'm not sure how easy that is to test for or how
> much of our existing code violates it, though.
> 
> thanks
> -- PMM

Problem is it's not uncommon for guests to create such
configs, and then just never access them.
So the thing to do would be to complain *on access*.

-- 
MST

