Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C3E4C775
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 08:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfFTGZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 02:25:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37425 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfFTGZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 02:25:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so1068908pfa.4
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 23:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IGLcxi13YQpGmz2iYHuA5KftYdvj4Iolhk4M1Lmi3sI=;
        b=HCwZI061L1anZnswV0RlaX0n65sNinKOrr+C7TmKCP09tOpY1Ak40fUmKsXCLyZtQg
         aq1Z0UU41888Ad7+dzzSQLNJT6MMqxe1cyAMLr0209VLxj8HFcDdhxeX/xoDNMlJLsPH
         5d8fEcTjHLZF8aNBXInl7z90RMLlvSRx4XkKVwL1hMGWqnCBo0+65ql6s2a8pyXOJgpD
         U34fVP2nRfc+8AiL3xn2CC4R9nW/gCUdaXUmQHohetq3JNhwLHlTCfZEPfmupBasnDfT
         jd3NJHOL4ET91N+a55DLCMODNZKlPmqMMJGVz87ujbWOwW0cJ3pyfvo5DIf3kK1q0O45
         FsnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGLcxi13YQpGmz2iYHuA5KftYdvj4Iolhk4M1Lmi3sI=;
        b=qVn5nE4fG0MImpcX5rEG8PoPWSG3G/itdMw7qWfT9rQqqxRBpl6JvsAuDfLfQhheWK
         +j29iM/Eko2ecVBaxDnHhk2DNPegpDuQCDGd6wCVV6BoRov3ojXdmmAP+UCqq3qZ4eua
         iCJnL2D6VT88Ro8pWQ1KAq0GjdQRpbV1MSf0TGWefQIZAAhHf2kMEv4HWulCYwK1eubv
         UtxofQyr5TTnpgRWvmg6yXPgP6r+8jE2BNwB2+qv99TcyVaSlJsavWngDF7y2EqN72Ht
         4ZU/pnkFDUH5d/tVslKcofvh8Ev+gANKBz0+8C/IUQCJEPKwh6mZV3MBphvaAhuFxSsV
         R48w==
X-Gm-Message-State: APjAAAV++27inUE1qf4vo7un3xB3BG3pr70MXbpItbSiAHNn8g4LSM7x
        ScqkRpg9o7xOpWIEloyUPn4=
X-Google-Smtp-Source: APXvYqxVzbq1iCFhiSI2h/imNXUolwSz/xpmVLL1+zpGNs6jkWM5f94oRYWmfV9TpS7wA0qUQ4nF0g==
X-Received: by 2002:a63:e317:: with SMTP id f23mr11574402pgh.142.1561011958327;
        Wed, 19 Jun 2019 23:25:58 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id m19sm10359270pjn.3.2019.06.19.23.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 23:25:57 -0700 (PDT)
Message-ID: <1561011953.4771.2.camel@gmail.com>
Subject: Re: [PATCH] kvm: add kvm cap values to debugfs
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, paulus@ozlabs.org, dja@axtens.net
Date:   Thu, 20 Jun 2019 16:25:53 +1000
In-Reply-To: <8f6429ac-f6a5-bf24-59c5-a101b75bfd40@redhat.com>
References: <20190528083535.27643-1-sjitindarsingh@gmail.com>
         <8f6429ac-f6a5-bf24-59c5-a101b75bfd40@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-05-28 at 12:35 +0200, Paolo Bonzini wrote:
> On 28/05/19 10:35, Suraj Jitindar Singh wrote:
> > KVM capabilities are used to communicate the availability of
> > certain
> > capabilities to userspace.
> > 
> > It might be nice to know these values without having to add debug
> > printing to the userspace tool consuming this data.
> 
> Why not write a separate script that prints the capability values?

I agree that this makes more sense as a standalone userspace script.
Dropping this patch.

Thanks,
Suraj

> 
> Paolo
