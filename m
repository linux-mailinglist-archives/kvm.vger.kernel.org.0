Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C735125DA90
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 15:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgIDNyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 09:54:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49335 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730665AbgIDNvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 09:51:25 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-zixu_x1sORKVp73i-vzmzQ-1; Fri, 04 Sep 2020 09:50:56 -0400
X-MC-Unique: zixu_x1sORKVp73i-vzmzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73E162FD01;
        Fri,  4 Sep 2020 13:50:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 649E37E416;
        Fri,  4 Sep 2020 13:50:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 06/10] configure: Add an option to
 specify getopt
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-7-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a4865b81-d9cd-9950-2550-59693ec8eee9@redhat.com>
Date:   Fri, 4 Sep 2020 15:50:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200901085056.33391-7-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/2020 10.50, Roman Bolshakov wrote:
> macOS is shipped with an old non-enhanced version of getopt and it
> doesn't support options used by run_tests.sh. Proper version of getopt
> is available from homebrew but it has to be added to PATH before invoking
> run_tests.sh. It's not convenient because it has to be done in each
> shell instance and there could be many if a multiplexor is used.
> 
> The change provides a way to override getopt and halts ./configure if
> enhanced getopt can't be found.
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  configure    | 13 +++++++++++++
>  run_tests.sh |  2 +-
>  2 files changed, 14 insertions(+), 1 deletion(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

