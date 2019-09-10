Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BAFAEFD6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436904AbfIJQoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 12:44:24 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38610 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436860AbfIJQoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 12:44:24 -0400
Received: by mail-io1-f65.google.com with SMTP id k5so13767789iol.5
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 09:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zBqeMk4J9HD30ebLnD2IzURrE2LeyX40xmHrpGfOfWo=;
        b=tGsTSXPBFzp43tFhYW3yhmARDO7/h3E4ug4qHk0hKP047QtQ+DfTnU+IkIAVzqS3Q5
         oOjaUkAYmsQPWvEyVsshEGbE9D+EP6WBpIKJ23v6xlvTKrXaQ/yQLha2J9AYgClGVzmT
         1ROvUr+JhQAm4TPb4R2mjAAbIALgAkvGBtJYE5dgQlDl9kJUgtVUqgprvx0IOPjC7Nqn
         xYOTFZ4zKrE34monKgUFTNLyO9nsKv3avvjxYnXXW/zNRc1DopkUWkiVF4MvAGvn+i+g
         5qm0kj3fAC4Ds6p/L1tjD83HMZ+v47hXoK/CmSyqU8v+PQvBsymME8nxO7wwnFsb2R9S
         LgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zBqeMk4J9HD30ebLnD2IzURrE2LeyX40xmHrpGfOfWo=;
        b=PFXoVleIivFWL/YqqESNLniJOGVdNebXw5eC9sK1BPzuJUGPicKx6REpNZvD4otWdB
         Y+0ljYTnkMp2GvUxcVvPdzYcrzPJuuVR8OmGmAYDC7QTfKRq9FxKJZjfbAc+1nvge901
         vSf1WOTZmMQ0gnrU58/PXLSUxx/upspPy6GLgf/Gdcy4c28pgiczU+1qAXN1UkDVcIxD
         +L/X25BXpK/vVpJvTuqFitTTAtd4dg3vqgvn8ujlWyin3Qacwf8iNNfbgCU3qHgOX3ND
         wGio5ZY0gxkLWzp7kXBf54kECW+ZjCdrZs7k8fSharYd8QVITjFmxuZdFYz9ZSCJ0WdP
         Ll3Q==
X-Gm-Message-State: APjAAAXDMFdoRpS4A6D2XB/DF35xu6sPMtTmc4B147FqqfpfJ6hbpR3k
        cykEaBDJFdcmOjPY3vyehdjSXBZC/+HlpO8vxvAd2A==
X-Google-Smtp-Source: APXvYqyyakJ9X+2rBmlMy2e6FNFpVHQkIOwxb1DUe+gkbO9qChKABQhac45fqmSINlAQDB1BTpB4E2MOtjL5XhdWK/w=
X-Received: by 2002:a5e:d616:: with SMTP id w22mr885702iom.118.1568133861443;
 Tue, 10 Sep 2019 09:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
In-Reply-To: <CAGG=3QV-0hPrWx8dFptjqbKMNfne+iTfq2e-KL89ebecO8Ta1w@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 09:44:10 -0700
Message-ID: <CALMp9eTPaXJRZKpHuinZJHkjX=gdv7hRMhmi12OnuC=Z7U3-Nw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: emulator: use "q" operand modifier
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 9, 2019 at 2:28 PM Bill Wendling <morbo@google.com> wrote:
>
> The extended assembly documentation list only "q" as an operand modifier
> for DImode registers. The "d" seems to be an AMD-ism, which appears to
> be only begrudgingly supported by gcc.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
