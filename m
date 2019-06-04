Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702C93522E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 23:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfFDVtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 17:49:14 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:56171 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 17:49:14 -0400
Received: by mail-it1-f196.google.com with SMTP id i21so455707ita.5
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 14:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4D3LiMWWbudPhFJl0C4DF+1HrFCMfX2xeT1uztDG6R4=;
        b=X/BbNGWBxDh3DpqK1vxfuK4ua4Hw9+F/iaFh/FoRCTi4f1mz7MtevgVOOPILlKUrkt
         zJPN+dLRkB1poYzk9DljfLy6zR5rJUhWWeUJrnPYYy211g7SMAUjtKU4O0NXJsj98K32
         ZuPMVeAB01SWIvgtsB+jtY5O4AzB3sCjkaIEcYoHknTosO/LVEmv3EEO3MjldcZtiHVc
         TBEIkPaeHwq8ldmh18DWRY2405+gd1RaTzDA7IkJ9LqBAww7tznonvWuSBvyzsfSf5WS
         jJmUkEvtos/KqOFm+uTDgxEsas1TpULqeKeiO73OT98CUO+/4If5gdbAkSbO43QXBTqU
         2h4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4D3LiMWWbudPhFJl0C4DF+1HrFCMfX2xeT1uztDG6R4=;
        b=Gof1aez2hB+etKi5aNNwJnbVoRh0uuj22E4ycWZsUNlaIqBZZNWZzTAkug0VtWAWpz
         Skd5U7P0/F6E03bWyL1c4ta4JP5t0yJRWnJUwlO5Rkn096kalOWtFfBfQ2g+qFHZdFh+
         LtHJnPGQRD1PNG56W2GYfKqRT6swuM1y6Xi6YJr7bTn7w6SoC10Zi8DIc6vyFRjbADco
         ufhYZkJih/D2IeCha5934EQ/2G8Hu9eIHbgMS+mtnyNy+zRbl2ILGyBYMBtwIgY5SWAg
         I8KUtZchKIxkiLcqBvI6NGNRTq8MsPWP6M2+3k9pzfrYQq9BVVnO6ipqWA2aO/rLEIit
         usSw==
X-Gm-Message-State: APjAAAUC0k9Pr6zaegNT18rZCN7Q/tJw8gBRYxGmC+92Pzq/XsVqtVYQ
        kEsStAATwGW+bTYL4+k9fTLCnowFOr2ZhZ9bDzNRSA==
X-Google-Smtp-Source: APXvYqxt0Vv5uScw7ho3V2tMzI68HYi79eAfo811aNcBB3MT24C2sfVpTu8/GZoJ07PDOxBjO3I4c5CQG1nQrltn2Sw=
X-Received: by 2002:a24:4415:: with SMTP id o21mr22569719ita.143.1559684953709;
 Tue, 04 Jun 2019 14:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190604203429.GA15407@dnote>
In-Reply-To: <20190604203429.GA15407@dnote>
From:   Eugene Korenevsky <ekorenevsky@gmail.com>
Date:   Wed, 5 Jun 2019 00:49:01 +0300
Message-ID: <CAJC2YLaFTTGBLaybCWDQa9m5=wRnbrb3+QJ11Wow7EEr+LBJLQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: vmx: take access length into account when
 checking the limit
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry, made mistake here (the `len` argument is not applied). Will
send the fixed version as v2 patchset.

>  int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
> -                       u32 vmx_instruction_info, bool wr, gva_t *ret)
> +                       u32 vmx_instruction_info, bool wr, int len, gva_t *ret)
>  {
>         gva_t off;
>         bool exn;

-- 
Eugene
