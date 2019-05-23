Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A8528464
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 18:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfEWQ6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 12:58:36 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:50768 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730899AbfEWQ6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 12:58:36 -0400
Received: by mail-it1-f196.google.com with SMTP id a186so1061561itg.0
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 09:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qvOckQPmf88tA3fBd0FnVt1+4Xz7hyduRt9XZLMQBao=;
        b=mqlPzKOcxvZnBc+OW2kAhF9H+ObZIEm2U98GTru5i4t1w5KsWaE9IrkNrTDf0HvApN
         uYa+/wbWkTnqAybyRmThn4vC+31/IisncdXMJdp7Hsom5igxFHW8aC5d94pUa7jjWR3+
         KxUiDFHsW847ykZucH5E4APgORtjbvijCVJEA2DSH5Sam3uuJrPBrQxyXVvx54FlXfuy
         0QLQpRqOrlluR92+j3KltDBfsjl6YIAlmAoMXPFY4Bx7UrcV1DCKoe6X58OCcApTV61s
         VnQKSs9KiBer165vSUMOMEqS6ZD+OJV1v05woSkq/7ukB6rVUb7okRqj+ArbRO/HDg50
         QNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qvOckQPmf88tA3fBd0FnVt1+4Xz7hyduRt9XZLMQBao=;
        b=Jd/H8njZKwrOu68YtX2fF9IZ97fKQVkFIqIKrLymBWrsDkBgqNAsMrCmaUWBkkwpLJ
         /9uVdwMuMDrwuND30n6RNqeAa7IlMwSGYVJb1zvY9SlsbRZsp2cF0hDBF32LIHORMqD+
         sRnvMCpRebbm/iMO3UF7X9X9QpChMcXUJ+msvGQCrAr6lq0EoD+fvb7X7nQEKlvTZuZZ
         VForQNCYWx/pM1TO1079sdn/ZOyOPspDda+bMxy0cWiamcwCMvSSb/RI5XVNXGcdYe9L
         HhMS5vUJyv3VUaeI6pda2oZHt7zk7JZO1UTB1M6PyYCpOHiop/nNJqGhhLRCQJY+yUm2
         16Uw==
X-Gm-Message-State: APjAAAXhYaU69SpaUideGRl+Fp29sLNBIKHeqVO8BoeeExPGoH1/y17N
        4TbtDBfKWwfVMJfVCk5NQ9aptqCSKuzt6P0haGvVWA==
X-Google-Smtp-Source: APXvYqyx1yJPWAjb/UBr1bd7va9J+5UIQXsEpvpYGZBX7xitFrb0F6QWIWILN568p+fYWPxN4nZlbD9aZNtl4uMSP+M=
X-Received: by 2002:a24:618f:: with SMTP id s137mr13726481itc.134.1558630715154;
 Thu, 23 May 2019 09:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190522234545.5930-1-krish.sadhukhan@oracle.com> <20190522234545.5930-2-krish.sadhukhan@oracle.com>
In-Reply-To: <20190522234545.5930-2-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 23 May 2019 09:58:24 -0700
Message-ID: <CALMp9eSgov_U_ZKr8MbBjzRhsDugBqL_3JJtHNdGvLYLN3VQAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm-unit-test: x86: Add a wrapper to check if the CPU
 supports NX bit in MSR_EFER
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 22, 2019 at 5:12 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
There will likely be a lot of these over time. Why not implement
something more generic, like static_cpu_has() in the kernel?
