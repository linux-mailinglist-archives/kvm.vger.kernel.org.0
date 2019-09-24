Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE83CBD2C2
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 21:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfIXTf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 15:35:58 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:33737 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfIXTf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 15:35:58 -0400
Received: by mail-vk1-f194.google.com with SMTP id q186so92149vkb.0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 12:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jx5FFDShDOpnNgD1gjgdx1I3Z4QuPfxYW1Gr4qXoUjg=;
        b=rqM/yN01+EC8jv2PivswKten0vrPvhajcAHVmKTRYQ32w7o2o0FSLWRnJom3AFyNH9
         Qw6DB9f2jM/pXtwnLMHQObQ7qn5a2q2WPnL+j+0hzK7+DmbCytxO2egnXvjB8DSe9rgm
         DdnfH5uameAHBMt/LlkGgaqQ1NkQOvwCYn0PxqDa+hfC9BTeBvk9nR2zmK2Cm8ApzfvE
         qtoTuLoybIAu8QYroP8EzSD7+INpO83r1THD9J4rtqvlHy8MMRdz9lW5bdsw4NQwtQSl
         Tef1JflFC0057RuP/BEx/BaZBnZR7R63bSq1JDWfH/nRybjAUP4YH/4CYZ6q2BbCpbCv
         DLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jx5FFDShDOpnNgD1gjgdx1I3Z4QuPfxYW1Gr4qXoUjg=;
        b=orRegF6F7b8x+82RTo+N/a9XUvisgcvCTKiolDf0+BkGLUiPBHODpfY8aC4acHJnr7
         7WJBVPxBPLnK93WuZJcTJMGSdT4qJYvCZafHX78syHjkYRqMQCl+oHUl5Sf6kozcDHC+
         mlDb4DqKtv/jgB3NPSJldRCHxoqX+jbiTdyupJYumbd1ACaYU7nDigPVru+eawfVF0XZ
         lgi2lTrnLAsVcjMKBIEtm9H1dfooTN/XZ2p5h1DYb6WfHva2tsHKfxiOc7pFhqazbxRy
         KlBLZ66svh6UviqLzS6vfnfIixb5IIA1+ma8G+2+yN0SeX7KisZ242mipnO+rJEKeZsI
         ELag==
X-Gm-Message-State: APjAAAWYZnW6wIXpKbM3TukMssB1z1lXkPTXc/nMWiNC3B/JYtTSKYVa
        /QWFzNVYrCXLV7ssjN5EdJUo8OcygiPasyRP+vvK
X-Google-Smtp-Source: APXvYqzNkMAOASS5U1gqW8s+T31zm3H2XOn41IEEo8wTo5zfDbu3ghi1tpX6crGpLYrlIJU9S3Bzyi+S5VfSF2C3Mms=
X-Received: by 2002:a1f:c2c3:: with SMTP id s186mr314364vkf.88.1569353756944;
 Tue, 24 Sep 2019 12:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
 <20190911190131.GF1045@linux.intel.com> <CAGG=3QUkr-i0vw8nxkEJJawasu7GY2de3ATRhWoxOkFg1MSZsQ@mail.gmail.com>
In-Reply-To: <CAGG=3QUkr-i0vw8nxkEJJawasu7GY2de3ATRhWoxOkFg1MSZsQ@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Tue, 24 Sep 2019 12:35:44 -0700
Message-ID: <CAGG=3QUCx3DBT2yyPL9QjhS=aRW22VurL07BGdTL3hf0f9qmcQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: debug: use a constraint that doesn't
 allow a memory operand
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Plain text now. Sorry for spam.


On Tue, Sep 24, 2019 at 12:33 PM Bill Wendling <morbo@google.com> wrote:
>
> + Paolo Bonzini, Radim Kr=C4=8Dm=C3=A1=C5=99
>
> On Wed, Sep 11, 2019 at 12:01 PM Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
>>
>> On Mon, Sep 09, 2019 at 02:00:35PM -0700, Bill Wendling wrote:
>> > The "lea" instruction cannot load the effective address into a memory
>> > location. The "g" constraint allows a compiler to use a memory locatio=
n.
>> > A compiler that uses a register destination does so only because one i=
s
>> > available. Use a general register constraint to make sure it always us=
es
>> > a register.
>> >
>> > Signed-off-by: Bill Wendling <morbo@google.com>
>> > ---
>>
>> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
