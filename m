Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7DC25DB4F
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbgIDOU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:20:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730705AbgIDOUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 10:20:37 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-comyIOmPOWGBl_G9iA7fGg-1; Fri, 04 Sep 2020 10:20:33 -0400
X-MC-Unique: comyIOmPOWGBl_G9iA7fGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53FBB1008561;
        Fri,  4 Sep 2020 14:20:32 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7655610013D7;
        Fri,  4 Sep 2020 14:20:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 09/10] travis.yml: Change matrix keyword
 to jobs
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-10-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <88d4544d-edf0-0d0f-a8e7-d5af0fc6f82b@redhat.com>
Date:   Fri, 4 Sep 2020 16:20:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200901085056.33391-10-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/2020 10.50, Roman Bolshakov wrote:
> jobs keyword is used throughout Travis documentation and matrix is an
> alias for it (according to Travis config validation):
> 
>   root: key matrix is an alias for jobs, using jobs
> 
> At first glance it's not clear if they're the same and if jobs
> documentation applies to matrix. Changing keyword name should make it
> obvious.
> 
> While at it, fix the Travis config warning:
> 
>   root: deprecated key sudo (The key `sudo` has no effect anymore.)
> 
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  .travis.yml | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 7bd0205..f3a8899 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -1,11 +1,10 @@
> -sudo: true
>  dist: bionic
>  language: c
>  cache: ccache
>  git:
>    submodules: false
>  
> -matrix:
> +jobs:
>    include:
>  
>      - addons:
> 

Seems to work.

Tested-by: Thomas Huth <thuth@redhat.com>

