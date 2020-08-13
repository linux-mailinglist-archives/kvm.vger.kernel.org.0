Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B217243514
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 09:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgHMHlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 03:41:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50037 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726081AbgHMHlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 03:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597304471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uz2WxYGnOsNnfvAPY1W4ogaawSTGiAath6o28Ci8zDc=;
        b=Dvmy48089bgt1LZ0SFC4KG31ukhENT5t46txJo7PwuWwLNYAJjlnASmLwU7y5YPiiE0M79
        TS6+KC9R99X3N8kRmZ4LJgQBRijvwWLEKEm2nyGtZ/Y9cTqVTUDjFl0WxLF7qlk4YvaWh8
        IyV5TDYuqpIYJKMdny+a9QSEB36oMYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188--AWWgjNVPwG5A4OPSxX3lA-1; Thu, 13 Aug 2020 03:41:09 -0400
X-MC-Unique: -AWWgjNVPwG5A4OPSxX3lA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E60E800D55;
        Thu, 13 Aug 2020 07:41:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47D3C5D9E8;
        Thu, 13 Aug 2020 07:41:02 +0000 (UTC)
Date:   Thu, 13 Aug 2020 09:40:59 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 1/4] common.bash: run `cmd` only if a
 test case was found
Message-ID: <20200813074059.y4qvrne5thm2olf2@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
 <20200812092705.17774-2-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092705.17774-2-mhartmay@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 11:27:02AM +0200, Marc Hartmayer wrote:
> It's only useful to run `cmd` in `for_each_unittest` if a test case
> was found. This change allows us to remove the guards from the
> functions `run_task` and `mkstandalone`.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  run_tests.sh            | 3 ---
>  scripts/common.bash     | 8 ++++++--
>  scripts/mkstandalone.sh | 4 ----
>  3 files changed, 6 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

