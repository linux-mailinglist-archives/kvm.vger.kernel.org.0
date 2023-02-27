Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41016A41A8
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 13:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjB0M0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 07:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0M0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 07:26:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213C5A5D9
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 04:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677500712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/D7tQ/gvj6J6RaU9Iv6dlgG5G7wnXshRvfDZGTvLJx4=;
        b=SzT5e3VdRKIiFaDry8Kv1JuwJaBCCXUoKw1GgqK8TSVP1RRvQ03F6+TH6N2S3PhtUE9aiF
        iP4oS2Pbgyxc4nkJIqLLmly0pXxjMKYUzK4lEAomvDTltXpJz4ImstZUjCglazA7tsjcfP
        KBOkZwVxjJk5PXzR4A96SkbpF5jzewU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-iPIuThf7OPm4zqBmIqJA2Q-1; Mon, 27 Feb 2023 07:25:09 -0500
X-MC-Unique: iPIuThf7OPm4zqBmIqJA2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45FC295D605;
        Mon, 27 Feb 2023 12:25:08 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.88])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 229BE40C6EC4;
        Mon, 27 Feb 2023 12:25:08 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 3457421E6A1F; Mon, 27 Feb 2023 13:25:07 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
        <20230222142105.84700-9-pmorel@linux.ibm.com>
        <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
        <0a93eb0e-2552-07b7-2067-f46d542126f4@redhat.com>
        <9e1cbbe11ac1429335c288e817a21f19f8f4af87.camel@linux.ibm.com>
Date:   Mon, 27 Feb 2023 13:25:07 +0100
In-Reply-To: <9e1cbbe11ac1429335c288e817a21f19f8f4af87.camel@linux.ibm.com>
        (Nina Schoetterl-Glausch's message of "Mon, 27 Feb 2023 11:49:51
        +0100")
Message-ID: <87v8jnqorg.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:

> On Mon, 2023-02-27 at 08:59 +0100, Thomas Huth wrote:

[...]

>> I'm not sure whether double inclusion works with the QAPI parser (since this 
>> might code to be generated twice) ... have you tried?
>
> I haven't, the documentation says:
>
>> Include directives
>> ------------------
>> 
>> Syntax::
>> 
>>     INCLUDE = { 'include': STRING }
>> 
>> The QAPI schema definitions can be modularized using the 'include' directive::
>> 
>>  { 'include': 'path/to/file.json' }
>> 
>> The directive is evaluated recursively, and include paths are relative
>> to the file using the directive.  Multiple includes of the same file
>> are idempotent.
>
> Which is why I thought it should work, but I guess this is a statement about
> including the same file twice in another file and not about including the same
> file from two files.

No, this is intended to say multiple inclusion is fine, regardless where
the include directives are.

An include directive has two effects:

1. If the included file has not been included already, pull in its
   contents.

2. Insert #include in generated C.  Example: qdev.json includes
   qom.json.  The generated qapi-*-qdev.h include qapi-types-qom.h.

   Including any required modules, as recommended by qapi-code-gen.rst,
   results in properly self-contained generated headers.

> But then, as far as I can tell, the build system only builds qapi-schema.json,
> which includes all other files, so it could apply.

Yes, qapi-schema.json is the main module, which includes all the others.

In fact, it includes all the others *directly*.  Why?

We generate documentation in source order.  Included material gets
inserted right at the first inclusion; subsequent inclusions have no
effect.

If we put all first inclusions right into qapi-schema.json, the order of
things in documentation is visible right there, and won't change just
because we change inclusions deeper down.

Questions?

