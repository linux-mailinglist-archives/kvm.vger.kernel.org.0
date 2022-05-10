Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22CB5223CF
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 20:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348808AbiEJSZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 14:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348824AbiEJSZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 14:25:04 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F728D4F8
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 11:21:06 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id f5so11894052ilj.13
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 11:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jEeZ1p0qMMTdlOXczDvydOCwVae9LkjsCB/K2n50LPI=;
        b=D/Xk7Tc6P2TkISeL5UxkUUYsUmX8eYGS1ilTnOmMTnmwVQ9bOgGqWUrOY364O2hlO0
         lUjCFBCinsL7dqi/oSyo6kzpJN1rwIKzSfGKrnOk4JXg7aLVu4PiWUxkJMIamJLztyW9
         dNzhPuJ5RUNQ1NoH9QkYwO+cLegSjadO5zgWG51yz1MIqd+HSREhyVUEFndQknjBCWnR
         pGCuF7+bChzBdiCAr4BLgX0LhZeYFh48OEzNfBAkNpJao8c39d6ym3WrL88g3aQ1BCER
         dWBWAPUJHL//c06YQGvm2AhT0Qn4oZDBFP3KoH/1ViYgMh2j+pzBT78JSkW8XF4EwSIU
         /60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jEeZ1p0qMMTdlOXczDvydOCwVae9LkjsCB/K2n50LPI=;
        b=fZqqyzCoJHPiKqxfymxfVQK+rQMxCuXdgaPvEdiF9Ik1Uzrol8hpbv448XRe2410yn
         iMCYbVH4lFtltf9HWKYaaHEAmqse22UXqg+vSNPjWwBAlUDoOEC0m+JRiMvLISQNugZf
         5S+mvP4dh+kS2QNTRzAokAPZXRdSoHsR30FeBzAV2Fo3PCIhymgBXy6Bnz+9wccxzfv3
         AkWTYKxPlpU+ZzlQfe7MdJO+DM9Y0/rY86Pe3CkXqfYhEo1WGw1+4+V5sii+UQM14VeC
         3JTNtZTLymeqnmWLKU8+8VQmWiLDYneINE7MIWubz/ancY/jmjOu3cfGjBLQvmbbpf04
         yARw==
X-Gm-Message-State: AOAM5323W0sr1szPykrXHrVpzQIO3DC8U/zR6+uvHG6FAZ+G/+Rw5iKX
        g4H3VtStJuU0wy4GAOY9/ChMqA==
X-Google-Smtp-Source: ABdhPJw/CUDfb4iezG+lEnhUkFZPmnPsUQbucW8IjzclKszEJHXdVKwxjsBeb8ERHi6Vjnk8Bzq2hw==
X-Received: by 2002:a05:6e02:144c:b0:2cf:7a91:50da with SMTP id p12-20020a056e02144c00b002cf7a9150damr9344674ilo.123.1652206865593;
        Tue, 10 May 2022 11:21:05 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a23-20020a056638059700b0032b3a781769sm4548409jar.45.2022.05.10.11.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:21:04 -0700 (PDT)
Date:   Tue, 10 May 2022 18:21:01 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com, pshier@google.com
Subject: Re: [PATCH v3 0/4] KVM: arm64: vgic: Misc ITS fixes
Message-ID: <YnqtDT+EebIc0eVX@google.com>
References: <20220510001633.552496-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Mon, May 09, 2022 at 05:16:29PM -0700, Ricardo Koller wrote:
> The purpose of this series is to help debugging failed ITS saves and
> restores.  Failures can be due to misconfiguration on the guest side:
> tables with bogus base addresses, or the guest overwriting L1 indirect
> tables. KVM can't do much in these cases, but one thing it can do to help
> is raising errors as soon as possible.

For the series:

Reviewed-by: Oliver Upton <oupton@google.com>

--
Thanks,
Oliver
