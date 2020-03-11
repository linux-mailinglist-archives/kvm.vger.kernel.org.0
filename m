Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996CE1825BC
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 00:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgCKXVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 19:21:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33627 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCKXVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 19:21:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id m5so2045850pgg.0
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 16:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5eiBg99YYHrlAxjCNvjNGTI4q/+L4CRApPkS5MR51wI=;
        b=BRXJifeOewSDVsRbWPQODDRYNGXQ79IE0qOAgkq+MsrP37AFi6JpNrR327wiBo9gAU
         p5LcGyQ4uvDxfE6Sy1m10puAe+S6BSLMTZvV6Iqk5lm/CfBOY17TURTw5tLUUFMYCHjf
         K1BpmisQ6gVjkFisJSWP/MG0vb4f4QBDg9g246AYEN37uOH7oX8R3FQVS3Zgm8R1rXmW
         7IYBtVhkP1bkzip47NSacM1T2gQw5FYLIzbLKwmMI54hFJ8FJ50bY2CYNJ9EjUUetm2j
         iQe9exDSUPb/u7WsxAseD+6qqAfzuDAsbTqjCdxYaBFT56cZrvH3OxP+KmpHnNlNSV/b
         eOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5eiBg99YYHrlAxjCNvjNGTI4q/+L4CRApPkS5MR51wI=;
        b=YiSl1Ax2w7wtOiBt3eVkt8TJlJwYK8yUvvSz/CR8is51sMvZAzPdNTl/EiOAZwegs6
         SOAekuHCVkLSd/76zI6A5WLomScIh+LA10+w3MfW0DxVInfuBNMKNL4j/0cpxJAW9bKg
         pDXyIk3o64IkwoFrBtKM3siobInaJJ76r4nK4inJ3imf99gscn2p1u4vdMxo2fMEGA5L
         wBnlyW2VCbohSQxPBeEa3EOSlHbjj7cvP9bwOJEgOPXwMoTUX7ItWp/k31xHFFsLV4tW
         V3+tYMOLZpLPs1FQpKOdOmdS5d+RSudC0L/7Y121nbnhH3nSpM0ZvzsGIMXuJTXZpnHS
         Qr/Q==
X-Gm-Message-State: ANhLgQ0G2lihi6QvhEd+b2MrDg58PaFrSyir8qZbBKyo804+jtGVQDPq
        ivsFJe2ZcnKQWWy8ecRvxcocMDg5MCI=
X-Google-Smtp-Source: ADFU+vvEwa9h/8DSeKM6MbgU5hOKXd1JFBGDBHT5eD7T5CRxGuoNdBaZHITimjElvIm81Cr7wz1n6w==
X-Received: by 2002:a63:1547:: with SMTP id 7mr4804452pgv.353.1583968870994;
        Wed, 11 Mar 2020 16:21:10 -0700 (PDT)
Received: from [10.235.171.60] ([73.93.152.208])
        by smtp.gmail.com with ESMTPSA id y18sm50902854pfe.19.2020.03.11.16.21.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 16:21:10 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200311231206.GL21852@linux.intel.com>
Date:   Wed, 11 Mar 2020 16:21:08 -0700
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E0581325-7501-438D-B547-4FEC4F2C2D28@gmail.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
 <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
 <20200311214657.GJ21852@linux.intel.com>
 <E53A1909-C614-401C-A22E-8A22B3E36225@gmail.com>
 <d5f0ba6a-8c7f-60b6-871b-615d11b08a1b@oracle.com>
 <20200311231206.GL21852@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mar 11, 2020, at 4:12 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Thu, Mar 12, 2020 at 12:54:05AM +0200, Liran Alon wrote:
>> Of course it was best if Intel would have shared their unit-tests for =
CPU
>> functionality (Sean? I'm looking at you :P), but I am not aware that =
they
>> did.
>=20
> Only in my dreams :-)  I would love to open source some of Intel's
> validation tools so that they could be adapted to hammer KVM, but =
it'll
> never happen for a variety of reasons.

FYI: In 2014 I ran Intel=E2=80=99s fuzzing-tool (Cafe) to test KVM and =
found (and
fixed) ~100 bugs. And I did not even test nested virtualization=E2=80=A6

=
http://www.cs.technion.ac.il/people/namit/online-publications/161-amit.pdf=


