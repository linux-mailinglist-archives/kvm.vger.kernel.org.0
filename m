Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4A7E0F29
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 02:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbfJWAXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 20:23:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36020 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbfJWAXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 20:23:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id 23so11002884pgk.3
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 17:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=/rPZ4HhwO2Y5OxYPZvTpAmk/8khmnCdcuj1jKDBcIYI=;
        b=PWMr/nMYg+m7WtNCPLVizhxiu8gyfLZI0qwKU6Yqp4oFhAsoLzwWin4tCq7I2oHIei
         iAuxmHtpkNw44YwnJVo1QUoaReR9DmkDLXMTJedbn0+8dhb6RU6C+u9Ltmj4XbZ8fqWM
         xP2Jj51dT1JuQLgl25G3zBtz6CXYBhEBscM0PODXuxtEddF9t/J3rU0w7Jp0y5yquS7/
         5dX4qJZp8G15mW7nLthkGTyUcF3X+UYcgilTiWO9BvErNmqsj6sVk8JMFJL1eIPDd/f6
         bIhlrg0o23AUNMSfTePJemTx+FFcPxq7SWdJIDlsC17QN2bhA1rtFuwcGr9ig5LnNbOf
         o4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=/rPZ4HhwO2Y5OxYPZvTpAmk/8khmnCdcuj1jKDBcIYI=;
        b=c2SJO9s6q51AT3dvkdELueLwsUh913L7nyMw1BOOctytVE6SFStScJsLGdIg7+XeqB
         R/4gKNzRnR7/xZ21AoFJujlvZ+RJ20KI/+Ts7K7s9mizhscvpIuTb1e4guHl31NUIzi6
         Eg7KW1Lyu1B1/pB0bLv3Wx8eLeymgwUFAgFCJ9vLFzZ1tUhrj89hGZHK/E79TDoSohuq
         pVZuzUXXkF6TpQGMOde+1dbsBDM5MoIJgFnmSZYSDTmJubPij1oKjhC7a7THNwXwydjz
         MIRvUITOByoZzja4kHCR/WvCH2mYX4mi+tCqjwVwnCrPI4swSFaEC4CzQ0hKS1DONcOz
         +naw==
X-Gm-Message-State: APjAAAXnY7yCT+9+IxKRmggGzLZjRZHQYH5DI4nPntRkFqBcpX/yFobR
        yvOenTUWF1F7V7N7paV+HBPNqw==
X-Google-Smtp-Source: APXvYqz+Z9nLdGje/5/GaGDSa9/q6bNKjeojhvbDbY03xj4oOhikScXlxlbbMaHu4V4ZTUwDYQLl8Q==
X-Received: by 2002:a17:90a:eace:: with SMTP id ev14mr8128545pjb.57.1571790228097;
        Tue, 22 Oct 2019 17:23:48 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id d7sm8201906pgv.6.2019.10.22.17.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 17:23:47 -0700 (PDT)
Date:   Tue, 22 Oct 2019 17:23:46 -0700 (PDT)
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
In-Reply-To: <cfc975bb-d520-82a4-6fbe-40d78ce2e822@amd.com>
Message-ID: <alpine.DEB.2.21.1910221723220.126424@chino.kir.corp.google.com>
References: <20191017223459.64281-1-Ashish.Kalra@amd.com> <alpine.DEB.2.21.1910190156210.140416@chino.kir.corp.google.com> <29887804-ecab-ae83-8d3f-52ea83e44b4e@amd.com> <alpine.DEB.2.21.1910211754550.152056@chino.kir.corp.google.com>
 <cfc975bb-d520-82a4-6fbe-40d78ce2e822@amd.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Oct 2019, Singh, Brijesh wrote:

> >>>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>>
> >>>> SEV INIT command loads the SEV related persistent data from NVS
> >>>> and initializes the platform context. The firmware validates the
> >>>> persistent state. If validation fails, the firmware will reset
> >>>> the persisent state and return an integrity check failure status.
> >>>>
> >>>> At this point, a subsequent INIT command should succeed, so retry
> >>>> the command. The INIT command retry is only done during driver
> >>>> initialization.
> >>>>
> >>>> Additional enums along with SEV_RET_SECURE_DATA_INVALID are added
> >>>> to sev_ret_code to maintain continuity and relevance of enum values.
> >>>>
> >>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >>>> ---
> >>>>    drivers/crypto/ccp/psp-dev.c | 12 ++++++++++++
> >>>>    include/uapi/linux/psp-sev.h |  3 +++
> >>>>    2 files changed, 15 insertions(+)
> >>>>
> >>>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> >>>> index 6b17d179ef8a..f9318d4482f2 100644
> >>>> --- a/drivers/crypto/ccp/psp-dev.c
> >>>> +++ b/drivers/crypto/ccp/psp-dev.c
> >>>> @@ -1064,6 +1064,18 @@ void psp_pci_init(void)
> >>>>    
> >>>>    	/* Initialize the platform */
> >>>>    	rc = sev_platform_init(&error);
> >>>> +	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> >>>> +		/*
> >>>> +		 * INIT command returned an integrity check failure
> >>>> +		 * status code, meaning that firmware load and
> >>>> +		 * validation of SEV related persistent data has
> >>>> +		 * failed and persistent state has been erased.
> >>>> +		 * Retrying INIT command here should succeed.
> >>>> +		 */
> >>>> +		dev_dbg(sp->dev, "SEV: retrying INIT command");
> >>>> +		rc = sev_platform_init(&error);
> >>>> +	}
> >>>> +
> >>>>    	if (rc) {
> >>>>    		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
> >>>>    		return;
> >>>
> >>> Curious why this isn't done in __sev_platform_init_locked() since
> >>> sev_platform_init() can be called when loading the kvm module and the same
> >>> init failure can happen that way.
> >>>
> >>
> >> The FW initialization (aka PLATFORM_INIT) is called in the following
> >> code paths:
> >>
> >> 1. During system boot up
> >>
> >> and
> >>
> >> 2. After the platform reset command is issued
> >>
> >> The patch takes care of #1. Based on the spec, platform reset command
> >> should erase the persistent data and the PLATFORM_INIT should *not* fail
> >> with SEV_RET_SECURE_DATA_INVALID error code. So, I am not able to see
> >> any  strong reason to move the retry code in
> >> __sev_platform_init_locked().
> >>
> > 
> > Hmm, is the sev_platform_init() call in sev_guest_init() intended to do
> > SEV_CMD_INIT only after platform reset?  I was under the impression it was
> > done in case any previous init failed.
> > 
> 
> 
> The PLATFORM_INIT command is allowed only when FW is in UINIT state. On
> boot, the FW will be in UNINIT state and similarly after the platform 
> reset command the FW goes back to UNINIT state.
> 
> The __sev_platform_init_locked() checks the FW state before issuing the
> command, if FW is already in INIT state then it returns immediately.
> 

Ah, got it, thanks.

Acked-by: David Rientjes <rientjes@google.com>
