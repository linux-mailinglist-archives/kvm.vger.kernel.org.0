Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8EADF9F7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbfJVA5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:57:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39290 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbfJVA5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:57:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id v4so9522687pff.6
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 17:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=P6RcNi5uOd1zBKqkT/UxYCKGepqZ9mx8RKHu653+b60=;
        b=Mgrj/IV/UOMgU2MuVVtmPeMxX+dYKZehrsDmNUOFzEVphmGX8rFvKNLhq5ICaXO+Gr
         TlNU9BVZZvKUASmDXgCyYGkdw2CoS4vLSV/y4e4nVY+03URTQVGbjD8u86Ie24bDhj3Z
         7t33zWaB0wWQK9vrnndS28gEgeiCK/hMWqJ4uT86ToJq8VkljiNyfG9ED+xfdxjRTuYT
         Bw6ycj92HqJK1Tt6OaPZfrwnPu0OrDIusjxpPaRBZ53XhbDq80yCVxPHoNje1Y/gEJit
         J3SQ6qzfWayU6N65dUYvUFa+GDQ/2I/MwtsYR7n2a/VCPZgyvmaTEsmNnX/Ua7IKw7O4
         6ZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=P6RcNi5uOd1zBKqkT/UxYCKGepqZ9mx8RKHu653+b60=;
        b=bl9Y4WBpCzVYGo5rE1HCbQ+YB9Ak5/FrTEe12ZxaBVHDrv9i0C6yBa8S9IBOtJB17C
         QMs5uWSVxtIxkUHSt8zYGvAY7lk3NO3PUArZpM5uLOKJf2EKxF3kdwSvOvaRN/1+hf4E
         Std92AO5fdMO7efLnliT3LIjE37FgG1HRVrGaR/z9d8qpjkIeNe0o2j96Q69fOLhoOGx
         UfRkK2Mx3C0JsWgj46DQ7+webOr6MAhURqy4NHepIJl1d1FqK0WH2ePAdOsv+BossYuf
         NAYYEWFaDEHe90riHA7eOO7hd5hlPnohItbfN1EQSMgYPt/DWSsBlnupMk+py0ofIEqZ
         f9ig==
X-Gm-Message-State: APjAAAV4OSHCZMdy0SSIUja0TJqMRt9Zqt+j3BT4W80Hy/FWbUxf5qXs
        bBLxUUTNrEX0pMhN1RT/TIIWqQ==
X-Google-Smtp-Source: APXvYqyu4LbDJfT2eWZ8/oHrrdSfHGvGWoVYo/oqgwjpzuYEe1iYBMFioC3k1wDjZ8k1+vs0m13lMA==
X-Received: by 2002:a62:1ccf:: with SMTP id c198mr1035187pfc.156.1571705853073;
        Mon, 21 Oct 2019 17:57:33 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id f21sm14561089pgh.85.2019.10.21.17.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 17:57:32 -0700 (PDT)
Date:   Mon, 21 Oct 2019 17:57:31 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "info@metux.net" <info@metux.net>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp - Retry SEV INIT command in case of integrity
 check failure.
In-Reply-To: <29887804-ecab-ae83-8d3f-52ea83e44b4e@amd.com>
Message-ID: <alpine.DEB.2.21.1910211754550.152056@chino.kir.corp.google.com>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com> <alpine.DEB.2.21.1910190156210.140416@chino.kir.corp.google.com> <29887804-ecab-ae83-8d3f-52ea83e44b4e@amd.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Oct 2019, Singh, Brijesh wrote:

> >> From: Ashish Kalra <ashish.kalra@amd.com>
> >>
> >> SEV INIT command loads the SEV related persistent data from NVS
> >> and initializes the platform context. The firmware validates the
> >> persistent state. If validation fails, the firmware will reset
> >> the persisent state and return an integrity check failure status.
> >>
> >> At this point, a subsequent INIT command should succeed, so retry
> >> the command. The INIT command retry is only done during driver
> >> initialization.
> >>
> >> Additional enums along with SEV_RET_SECURE_DATA_INVALID are added
> >> to sev_ret_code to maintain continuity and relevance of enum values.
> >>
> >> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >> ---
> >>   drivers/crypto/ccp/psp-dev.c | 12 ++++++++++++
> >>   include/uapi/linux/psp-sev.h |  3 +++
> >>   2 files changed, 15 insertions(+)
> >>
> >> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> >> index 6b17d179ef8a..f9318d4482f2 100644
> >> --- a/drivers/crypto/ccp/psp-dev.c
> >> +++ b/drivers/crypto/ccp/psp-dev.c
> >> @@ -1064,6 +1064,18 @@ void psp_pci_init(void)
> >>   
> >>   	/* Initialize the platform */
> >>   	rc = sev_platform_init(&error);
> >> +	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> >> +		/*
> >> +		 * INIT command returned an integrity check failure
> >> +		 * status code, meaning that firmware load and
> >> +		 * validation of SEV related persistent data has
> >> +		 * failed and persistent state has been erased.
> >> +		 * Retrying INIT command here should succeed.
> >> +		 */
> >> +		dev_dbg(sp->dev, "SEV: retrying INIT command");
> >> +		rc = sev_platform_init(&error);
> >> +	}
> >> +
> >>   	if (rc) {
> >>   		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
> >>   		return;
> > 
> > Curious why this isn't done in __sev_platform_init_locked() since
> > sev_platform_init() can be called when loading the kvm module and the same
> > init failure can happen that way.
> > 
> 
> The FW initialization (aka PLATFORM_INIT) is called in the following
> code paths:
> 
> 1. During system boot up
> 
> and
> 
> 2. After the platform reset command is issued
> 
> The patch takes care of #1. Based on the spec, platform reset command
> should erase the persistent data and the PLATFORM_INIT should *not* fail
> with SEV_RET_SECURE_DATA_INVALID error code. So, I am not able to see
> any  strong reason to move the retry code in
> __sev_platform_init_locked().
> 

Hmm, is the sev_platform_init() call in sev_guest_init() intended to do 
SEV_CMD_INIT only after platform reset?  I was under the impression it was 
done in case any previous init failed.
