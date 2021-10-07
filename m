Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5C64252F2
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241308AbhJGM12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 08:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241197AbhJGM12 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 08:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633609534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPzCUic6CYIMy5ARHGSfae0aVwrn1CpgSsq1foikCFo=;
        b=Ip64Ea21sg8e/3GjPft2cUL/siACw0CiSMNuAc9Mmh+0lYZcoXKOrZbSLKsJiUwohn/Ic/
        G8I+n1Zx8hGeTxy8Z8fBSmQqntpovbrS+tn/0uPv/mGa5BQKQoxH9W67ty2LG5/B2WpnvK
        qyvPueEXytAZbxAZBu51vZXJH6BnmUQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-xLTmpATrPPGGvDnlwnSPPw-1; Thu, 07 Oct 2021 08:25:33 -0400
X-MC-Unique: xLTmpATrPPGGvDnlwnSPPw-1
Received: by mail-wr1-f69.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso4577914wrg.7
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 05:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=wPzCUic6CYIMy5ARHGSfae0aVwrn1CpgSsq1foikCFo=;
        b=Ltd61WTk5SKTyC/CE4jDAHNaHOHyE2Lt730PB+i4qK2n50wiaqoSeW4+BEhZNP8y8Y
         3NaLgF1j5Ov4paIT2lYTs/aMw5wEiEumKSCqDexUBsqSjavDZK7q05yKJWk+ksSLFiH7
         xjS/DwMaJfRrRGDwGqHTefe4RkSrf/RJeez5JSNghnC8JDLmWpfRBdZkZa4fgMyK2XGt
         bU2FpEcf5V1pgFLvsu9jeEHtKsXCsKipYOuaY1V2fZe25QCMZ1Pyq3qAt4YXQ0z/mOxm
         r5sfYWhwvYLbJ3VAqPKa/zq4s3AmbsmfAqxWFN2YP/rI1oGFRAUaVeb8BTVc+vDWxTDA
         1/lQ==
X-Gm-Message-State: AOAM532tO8JCduVelRlE3kWvHS1DMF/vl3eFMmCA1toJ987wo5Su+bAN
        qmgEK0w0DmxDVtzvDmyeuunpbHC6ajZ0IliBtqTSo8vA5EspkmAfPJiWRvYYOELCOjCkidj+zTr
        5r0Bi2laplcRU
X-Received: by 2002:adf:a413:: with SMTP id d19mr5034975wra.246.1633609532109;
        Thu, 07 Oct 2021 05:25:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhng+oeuXPF66rcVW/Ky2EelAOIslOG8kX+JhVf4qUHjTpWyaYVL3GY9nKDyOtcqagNm5w0g==
X-Received: by 2002:adf:a413:: with SMTP id d19mr5034951wra.246.1633609531928;
        Thu, 07 Oct 2021 05:25:31 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id q3sm5544623wmf.11.2021.10.07.05.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 05:25:31 -0700 (PDT)
Date:   Thu, 7 Oct 2021 13:25:28 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Sergio Lopez <slp@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Connor Kuehl <ckuehl@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org
Subject: Re: [PATCH v3 05/22] target/i386/monitor: Return QMP error when SEV
 is disabled in build
Message-ID: <YV7nOJolgSSIX5Wf@work-vm>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-6-philmd@redhat.com>
 <bef20bd5-7760-3fc7-9914-1eddca800825@redhat.com>
 <8f12bc3e-53aa-c946-bb06-f7d08721b243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f12bc3e-53aa-c946-bb06-f7d08721b243@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
> On 10/4/21 10:11, Paolo Bonzini wrote:
> > On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> >> If the management layer tries to inject a secret, it gets an empty
> >> response in case the binary built without SEV:
> >>
> >>    { "execute": "sev-inject-launch-secret",
> >>      "arguments": { "packet-header": "mypkt", "secret": "mypass",
> >> "gpa": 4294959104 }
> >>    }
> >>    {
> >>        "return": {
> >>        }
> >>    }
> >>
> >> Make it clearer by returning an error, mentioning the feature is
> >> disabled:
> >>
> >>    { "execute": "sev-inject-launch-secret",
> >>      "arguments": { "packet-header": "mypkt", "secret": "mypass",
> >> "gpa": 4294959104 }
> >>    }
> >>    {
> >>        "error": {
> >>            "class": "GenericError",
> >>            "desc": "this feature or command is not currently supported"
> >>        }
> >>    }
> >>
> >> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> >> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> >> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> >> ---
> >>   target/i386/monitor.c | 5 +++++
> >>   1 file changed, 5 insertions(+)
> >>
> >> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> >> index 196c1c9e77f..a9f85acd473 100644
> >> --- a/target/i386/monitor.c
> >> +++ b/target/i386/monitor.c
> >> @@ -28,6 +28,7 @@
> >>   #include "monitor/hmp-target.h"
> >>   #include "monitor/hmp.h"
> >>   #include "qapi/qmp/qdict.h"
> >> +#include "qapi/qmp/qerror.h"
> >>   #include "sysemu/kvm.h"
> >>   #include "sysemu/sev.h"
> >>   #include "qapi/error.h"
> >> @@ -743,6 +744,10 @@ void qmp_sev_inject_launch_secret(const char
> >> *packet_hdr,
> >>                                     bool has_gpa, uint64_t gpa,
> >>                                     Error **errp)
> >>   {
> >> +    if (!sev_enabled()) {
> >> +        error_setg(errp, QERR_UNSUPPORTED);
> >> +        return;
> >> +    }
> >>       if (!has_gpa) {
> >>           uint8_t *data;
> >>           struct sev_secret_area *area;
> >>
> > 
> > This should be done in the sev_inject_launch_secret stub instead, I
> > think.  Or if you do it here, you can remove the "if (!sev_guest)"
> > conditional in the non-stub version.
> 
> This part is not related to SEV builtin; what we want to avoid here
> is management layer to try to inject secret while the guest hasn't
> been started with SEV (IOW 'no memory encryption requested for KVM).
> 
> Maybe this error message is more explicit?
> 
>   error_setg(errp, "Guest is not using memory encryption");
> 
> Or:
> 
>   error_setg(errp, "Guest is not using SEV");

This is better; there's a separate feature called memory encryption, so
we don't want to confuse things.

Dave

> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

