Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA3550A0A6
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiDUNYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 09:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiDUNYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 09:24:48 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4CD32EDC
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 06:21:59 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i27so9982375ejd.9
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 06:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bXKpCYOj7t5BTPU5Wz9Ftw9cLOsid4GfV8dHQSkHd4o=;
        b=joRBLzIQeXqtjzT9eaoBB9pMC8QXEJyX4Tvbdj14LJYa8ePIyVTTUx6BsluwFjnR1/
         HEypwr6hZPa9K51uwAM+mqB+4jCKf/HL6QYDsPSPHeBplmqqCCkSouKRgcxR7oXU+LZy
         JnCdjEb5abHlvdkHEy0yTCTsj6v8oXeDODKtTz1Z9MRmLCL5o7EgzBaKYqVXMgnAVBTi
         glNS6gATueFfFmQpvMxE0CyfSvrd+ySR0fTuSXemP7mP9yEXPsxZwITUyFbJ3LJiIEpY
         kBdhSVUmzoOl18V0Q5eTPLHb5w6h0tYMNzxun41SeG79AYgp7mY5A5gTwSJyUEzIuTXf
         CgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bXKpCYOj7t5BTPU5Wz9Ftw9cLOsid4GfV8dHQSkHd4o=;
        b=OqLAkMMxuKMtmVsx30f4sAILcDBzkRrsF8S4d+JS91oaytwgvSylIC9yeUm/mv4kPE
         ksWoOg8HTfx+yy16IXLanEaph+5Wwigl2s868rUyTyIRKTHItbKieSaK7LW23noi8CjH
         TlVfRgj4lHJpKOQBKUicfKqccftZS1+tjlGxAnHW7z1G6DlFQAYzBLYW7MX44COwKrk4
         8D1XUumcewStCTXtXsVW4UGX6VuV3Z6NJljdPUepwofMEEuZdiu3+fZqKv0wRdOG8XC9
         en3CABTyIPUPCqEmw+4EJYvf+NF88bSOKz0O/FBsh02Pa5fWjLDVJx/obAPtQQnpHqX6
         umLw==
X-Gm-Message-State: AOAM530NQPvnjXeYNeoAHOndSCKuVCu6lHnp8wdcx8jq3q4b8edtjjjE
        mmnCK+iC4QQsjoAhWbS8d4t4vA==
X-Google-Smtp-Source: ABdhPJx1L9hShjNwK94hggJJiK6IFYK/sCAP5IkmWVOxrAJcbXpmJ83JIVZImsLcCV+kjJl8XfiyJA==
X-Received: by 2002:a17:906:8554:b0:6e8:c43c:12b3 with SMTP id h20-20020a170906855400b006e8c43c12b3mr22510752ejy.331.1650547317768;
        Thu, 21 Apr 2022 06:21:57 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com. [34.91.171.30])
        by smtp.gmail.com with ESMTPSA id d11-20020a056402400b00b00423e5bdd6e3sm6063712eda.84.2022.04.21.06.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:21:57 -0700 (PDT)
Date:   Thu, 21 Apr 2022 13:21:54 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmFactP0GnSp3vEv@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-10-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Friday 15 Apr 2022 at 21:58:53 (+0000), Oliver Upton wrote:
> Breaking a table pte is insufficient to guarantee ownership of an
> unlinked subtree. Parallel software walkers could be traversing
> substructures and changing their mappings.
> 
> Recurse through the unlinked subtree and lock all descendent ptes
> to take ownership of the subtree. Since the ptes are actually being
> evicted, return table ptes back to the table walker to ensure child
> tables are also traversed. Note that this is done both in both the
> pre-order and leaf visitors as the underlying pte remains volatile until
> it is unlinked.

Still trying to get the full picture of the series so bear with me. IIUC
the case you're dealing with here is when we're coallescing a table into
a block with concurrent walkers making changes in the sub-tree. I
believe this should happen when turning dirty logging off?

Why do we need to recursively lock the entire sub-tree at all in this
case? As long as the table is turned into a locked invalid PTE, what
concurrent walkers are doing in the sub-tree should be irrelevant no?
None of the changes they do will be made visible to the hardware anyway.
So as long as the sub-tree isn't freed under their feet (which should be
the point of the RCU protection) this should be all fine? Is there a
case where this is not actually true?

Thanks,
Quentin
