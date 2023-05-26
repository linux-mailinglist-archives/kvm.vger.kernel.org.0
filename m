Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0B71224A
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 10:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242740AbjEZIe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 04:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242748AbjEZIes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 04:34:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5A6128;
        Fri, 26 May 2023 01:34:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-25376483f66so451091a91.0;
        Fri, 26 May 2023 01:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685090087; x=1687682087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1AB18/+VPofNdgVVfpkQbQ+ysDkEYSuV7ztvKqEjdA=;
        b=B3WcL/au1RZpNmcuqrpLzIqE3imXF7YKBx4vb1bIjkiA+v4dsJ0t/DBRGpf3v+EFvR
         uxl0TUfQ1QwkF138U6R7QPV+/bIBSBZqSJoP2oz7eDG2K8/zIU5ASeW6RfIjIZpT1lt/
         QKoFxTlFuVFYj3cBP4Pk1WkN5pwH8KciEzT25Qwt4DRA3THQFb6dmLkvc7YVglc2qfK0
         hqUWiwooSOSrfvGNj35yXwYQU+BzXoNMsvyPYsuF1wmSNZmMkOdmL+UTi+yF6O41TSQl
         Ye0rlCEGdO+P7esifRlrLQisWwoZ0v+gnFCe5y5XL9suZtKW6mcaknHbDNCMFe+qBBP8
         4P1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685090087; x=1687682087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1AB18/+VPofNdgVVfpkQbQ+ysDkEYSuV7ztvKqEjdA=;
        b=PUsfr+C6P6TQVPIyBtsKXsn9Psys36co+NcRk7Iy0QJX/W5DCkaOwHB4A56e+C6RPz
         4LIqTDx3eHY3vkJZM88nm8o2MnNDVS/ju9De7T0pnEI+a9pF/7514hDh+SRq2SNAQhc3
         sQUAleCt+9p3nnvjl9uIcIA14ApZqoOTfA5MSybH9/AGKBGrOBPacGJyln4Bjdb/eKzF
         rrVxesUrMx78iflRxC/B/U6wEJrqLhHN4FGzy3Fzk18WlnPzc3SZml1fTltGZW+kXaEd
         5Vf0HkHBGghwC0CUgFZCuyptMj5s+M7PM4XcgClvi/9UQDFyhzFEc+KewT3A+NU7yVwM
         FFYg==
X-Gm-Message-State: AC+VfDys2iIb4VkbKjyeF8JCfb4blHdfwW7a+Mn4q9pRVYULj9+qHGKv
        eP0o1wLA4TG1HrIRXZRznzOlgVDx1gY=
X-Google-Smtp-Source: ACHHUZ6aqfXlmWrBKADGELzaGcFpJTazMOjtftfE1A8IxNlikRUWTcmBhY6iXiTHJKiQGh6Rp6mXEg==
X-Received: by 2002:a17:90a:6fa1:b0:256:2b9e:e0b with SMTP id e30-20020a17090a6fa100b002562b9e0e0bmr1290023pjk.27.1685090087364;
        Fri, 26 May 2023 01:34:47 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-28.three.co.id. [180.214.232.28])
        by smtp.gmail.com with ESMTPSA id i17-20020a17090332d100b001ab0d815dbbsm2715151plr.23.2023.05.26.01.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 01:34:46 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 3523C106212; Fri, 26 May 2023 15:34:42 +0700 (WIB)
Date:   Fri, 26 May 2023 15:34:42 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Fabio Coatti <fabio.coatti@gmail.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
Message-ID: <ZHBvIpQoH_zjMSSW@debian.me>
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023 at 09:43:17AM +0200, Fabio Coatti wrote:
> Hi all,
> I'm using vanilla kernels on a gentoo-based laptop and since 6.3.2 I'm
> getting the kernel log  below when using kvm VM on my box.
> I know, kernel is tainted but avoiding to load nvidia driver could
> make things complicated on my side; if needed for debug I can try to
> avoid it.

Can you try uninstalling nvidia driver (should make kernel not tainted
anymore) and reproduce this regression?

-- 
An old man doll... just what I always wanted! - Clara
