Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413B3A2C2A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 03:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfH3BMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 21:12:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46506 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfH3BMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 21:12:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id q139so3354535pfc.13
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 18:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kCTRSL9QD9A19TQM7l1DPuOYasStlYMpBTNlp3Cc7WU=;
        b=kvapemHg9VS6qeap+IOziXN+q8oEYq8ub8oKrqIj9oGbzrFgxIMxYsoxF216sjVDFQ
         Ah0YP5cyxaBDT7zJakkvNr9u1+TgIg525c0+O61dn/eGAtOwkX5dvqBJeGgz7QWIZJL8
         PXJkbX7vDqMYs9TUVPeUaSIn3yMp+W8uEgM+eSo8Uhc7JajZUtIfomtm1Rz62yJg+VzF
         ampMobpFfFbJQt46QPRx9NRRe07ANgG32Ay8+vq5tEv10jZofd1OLwd8y0jkZaydiTjf
         TirSVz5pN01+fqDHJmRY2waPSqzliG/cx7dpj9utvKeyOdKuY7y118o4u42N+C54ADzK
         WA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kCTRSL9QD9A19TQM7l1DPuOYasStlYMpBTNlp3Cc7WU=;
        b=sfoPTyKwG/c3h9+n1WyCO+VrpuFLLJzah3h/lqKOue0AfDLpwn7VSMGAXKU9E/Ktoa
         XllvDkRYOEXenyTrkWSriDLFFnquLLKHcsYR5p9T2TGKM2OZ+ugbTfOZrQAy/ptMoW+7
         X7jRzyi1iYJ20ltR4UAc9TZLVUXdxtRMSyy/ywT2r5Cmqj7T/5wIO/+vnk3LPxyYHWtQ
         7wtIs+QlmX1mMpueXQeloGI4uc0T64iYAWdWoBIIeTgKmqYNEN4mio9Qz197TcCDeUg/
         1rO5S1bU1Gve7hr5Q3vE/CVR8A7TmGi7/TTNuMcryqRrOFFtEoYRulAl36akESsDPCPY
         g8EA==
X-Gm-Message-State: APjAAAVosGRtRSuBNm5qeW/+2Ex1T06Pk8DvHBPSKOFuyhEbio/mJca4
        fR/snJhSHeXJY1J0VZW5yOE=
X-Google-Smtp-Source: APXvYqxNcvDrzXRtElhf/hua4i0glSYAtHerC+z9mEKDbRpIaStVs65qsfx70podIU2725ealjH0lA==
X-Received: by 2002:a63:2887:: with SMTP id o129mr10702584pgo.179.1567127551676;
        Thu, 29 Aug 2019 18:12:31 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id p189sm4371042pfb.112.2019.08.29.18.12.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 18:12:30 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 4/4] kvm-unit-test: nVMX: Check GUEST_DEBUGCTL and
 GUEST_DR7 on vmentry of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eTBwNExJ_7+i6y7XcvQobSbAfhfMCs3u1G0zUZ+nQhkjg@mail.gmail.com>
Date:   Thu, 29 Aug 2019 18:12:26 -0700
Cc:     kvm list <kvm@vger.kernel.org>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AC03372E-DC8C-4494-BFFA-6BB85DC6B896@gmail.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-5-krish.sadhukhan@oracle.com>
 <CALMp9eTBwNExJ_7+i6y7XcvQobSbAfhfMCs3u1G0zUZ+nQhkjg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Aug 29, 2019, at 4:17 PM, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Thu, Aug 29, 2019 at 2:30 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> According to section "Checks on Guest Control Registers, Debug =
Registers, and
>> and MSRs" in Intel SDM vol 3C, the following checks are performed on =
vmentry
>> of nested guests:
>>=20
>>    If the "load debug controls" VM-entry control is 1,
>>=20
>>       - bits reserved in the IA32_DEBUGCTL MSR must be 0 in the field =
for
>>         that register. The first processors to support the =
virtual-machine
>>         extensions supported only the 1-setting of this control and =
thus
>>         performed this check unconditionally.
>>=20
>>       - bits 63:32 in the DR7 field must be 0.
>>=20
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>> ---
>> ...
>> +#define        DEBUGCTL_RESERVED_BITS  0xFFFFFFFFFFFF203C
>=20
> For the virtual CPU implemented by kvm today, only bits 0 and 1 are =
allowed.

Please build the tests so they would pass on bare-metal.

