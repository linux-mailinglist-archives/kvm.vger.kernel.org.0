Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53A175C83
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 15:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgCBODO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 09:03:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39048 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCBODO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 09:03:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so12750392wrn.6;
        Mon, 02 Mar 2020 06:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z+UglYKv1Dwx2e9r/aDCnJWSItXjpOM15W1jiZYfefY=;
        b=k8ibSYJfZIjWpokZexvmy9Tj8CRVHdGfFNGLIaR/hdN67UdLuIm1Jlc51F0+W6n0Je
         wtEU1l3fHJ+jK6iadBJJbNOuGzlEib5M7jqcKGx22f1lPyAMJvRL7QMRrO3HCxyxa720
         a1+uKYIYMtiyH9qzRY6bv67RCJHN7cBAlR+hcHTczsP1v2sHZTB99VsOM/AsqcHdJ5dC
         UYL7t+Ib7dFlv5Obt6ENpELMBRGuXHKkWUy3cxttqNDLHfwl9+01I7kFj6NK08Ohdb6F
         HCkL+bVZNVIsr/8zmlVQu8XhUKX+DFufY0SciPeqdfPuFgfaY/5/5tGOGjrY2KD/f08Y
         UJRQ==
X-Gm-Message-State: APjAAAUSpMw+fmjadJ35AGG8iUYh/rxcBENDS6BaOUKuee5BCKrEZex5
        8YkBmus3LlDYstOWmvGOujs=
X-Google-Smtp-Source: APXvYqzNlCJ57BpY/mMPxIq3KUzXka2/8lIi9TR4CaC2Gp0sGaxqiJbgkHNQYdBVahmYIfvhPV/tig==
X-Received: by 2002:adf:fe0a:: with SMTP id n10mr23857788wrr.229.1583157792337;
        Mon, 02 Mar 2020 06:03:12 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id j4sm17021673wrr.0.2020.03.02.06.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 06:03:11 -0800 (PST)
Date:   Mon, 2 Mar 2020 15:03:09 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 01/11] ACPI: NUMA: export pxm_to_node
Message-ID: <20200302140309.GM4380@dhcp22.suse.cz>
References: <20200302134941.315212-1-david@redhat.com>
 <20200302134941.315212-2-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302134941.315212-2-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon 02-03-20 14:49:31, David Hildenbrand wrote:
> Will be needed by virtio-mem to identify the node from a pxm.

No objection to export the symbol. But it is almost always better to add
the export in the patch that actually uses it. The intention is much
more clear that way.

> Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Michal Hocko <mhocko@suse.com> # for the export

> ---
>  drivers/acpi/numa/srat.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
> index 47b4969d9b93..5be5a977da1b 100644
> --- a/drivers/acpi/numa/srat.c
> +++ b/drivers/acpi/numa/srat.c
> @@ -35,6 +35,7 @@ int pxm_to_node(int pxm)
>  		return NUMA_NO_NODE;
>  	return pxm_to_node_map[pxm];
>  }
> +EXPORT_SYMBOL(pxm_to_node);
>  
>  int node_to_pxm(int node)
>  {
> -- 
> 2.24.1
> 

-- 
Michal Hocko
SUSE Labs
