Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A641C726E
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgEFOFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 10:05:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42000 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728058AbgEFOFa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 10:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588773928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=esu9AiwJiFUnyAcbLuuk+p4TG/gg2mgs+ePfNBxDfYU=;
        b=JcGrcdeINatokoaYLIPeQGBXc/0UEeiLHRqE3psvpVdgeOdbtAlZYyFFLYSVzTEvheJ32W
        Cqna/fyYKzT2hcWCM+qf+pVmKxwd+Bq5NUmM6nEQd21BFuCyuDETdLPgA1EuVSiuJEuZwo
        3AsZSJK7Z048SE0OWXrOfdM/mmf4LfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-lLZQIyKTOx-VRuylu9z_kw-1; Wed, 06 May 2020 10:05:22 -0400
X-MC-Unique: lLZQIyKTOx-VRuylu9z_kw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD61787308F;
        Wed,  6 May 2020 14:05:21 +0000 (UTC)
Received: from [10.36.113.17] (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3FD462A10;
        Wed,  6 May 2020 14:05:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests RFC] s390x: Add Protected VM support
To:     Janosch Frank <frankja@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
References: <20200506124636.21876-1-mhartmay@linux.ibm.com>
 <ad0d5c9d-bde2-2143-0440-d47d6e28bb29@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <9d13ba18-fede-20fc-7b04-b6b0933971d1@redhat.com>
Date:   Wed, 6 May 2020 16:05:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ad0d5c9d-bde2-2143-0440-d47d6e28bb29@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.05.20 16:03, Janosch Frank wrote:
> On 5/6/20 2:46 PM, Marc Hartmayer wrote:
>> Add support for Protected Virtual Machine (PVM) tests. For starting a
>> PVM guest we must be able to generate a PVM image by using the
>> `genprotimg` tool from the s390-tools collection. This requires the
>> ability to pass a machine-specific host-key document, so the option
>> `--host-key-document` is added to the configure script.
>>
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  .gitignore          |  1 +
>>  configure           |  8 ++++++++
>>  s390x/Makefile      | 16 +++++++++++++---
>>  s390x/unittests.cfg | 20 ++++++++++++++++++++
>>  scripts/common.bash | 30 +++++++++++++++++++++++++++++-
>>  5 files changed, 71 insertions(+), 4 deletions(-)
>>
>> diff --git a/.gitignore b/.gitignore
>> index 784cb2ddbcb8..1fa5c0c0ea76 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -4,6 +4,7 @@
>>  *.o
>>  *.flat
>>  *.elf
>> +*.img
>>  .pc
>>  patches
>>  .stgit-*
>> diff --git a/configure b/configure
>> index 5d2cd90cd180..29191f4b0994 100755
>> --- a/configure
>> +++ b/configure
>> @@ -18,6 +18,7 @@ u32_long=
>>  vmm="qemu"
>>  errata_force=0
>>  erratatxt="errata.txt"
>> +host_key_document=
>>  
>>  usage() {
>>      cat <<-EOF
>> @@ -40,6 +41,8 @@ usage() {
>>  	                           no environ is provided by the user (enabled by default)
>>  	    --erratatxt=FILE       specify a file to use instead of errata.txt. Use
>>  	                           '--erratatxt=' to ensure no file is used.
>> +	    --host-key-document=HOST_KEY_DOCUMENT
>> +	                           host-key-document to use (s390x only)
>>  EOF
>>      exit 1
>>  }
>> @@ -91,6 +94,9 @@ while [[ "$1" = -* ]]; do
>>  	--erratatxt)
>>  	    erratatxt="$arg"
>>  	    ;;
>> +	--host-key-document)
>> +	    host_key_document="$arg"
>> +	    ;;
>>  	--help)
>>  	    usage
>>  	    ;;
>> @@ -207,6 +213,8 @@ PRETTY_PRINT_STACKS=$pretty_print_stacks
>>  ENVIRON_DEFAULT=$environ_default
>>  ERRATATXT=$erratatxt
>>  U32_LONG_FMT=$u32_long
>> +GENPROTIMG=genprotimg
>> +HOST_KEY_DOCUMENT=$host_key_document
>>  EOF
>>  
>>  cat <<EOF > lib/config.h
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ddb4b48ecbf9..a57655dcce10 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -17,12 +17,19 @@ tests += $(TEST_DIR)/stsi.elf
>>  tests += $(TEST_DIR)/skrf.elf
>>  tests += $(TEST_DIR)/smp.elf
>>  tests += $(TEST_DIR)/sclp.elf
>> -tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>  
>> -all: directories test_cases test_cases_binary
>> +tests_binary = $(patsubst %.elf,%.bin,$(tests))
>> +ifneq ($(HOST_KEY_DOCUMENT),)
>> +tests_pv_img = $(patsubst %.elf,%.pv.img,$(tests))
>> +else
>> +tests_pv_img =
>> +endif
>> +
>> +all: directories test_cases test_cases_binary test_cases_pv
>>  
>>  test_cases: $(tests)
>>  test_cases_binary: $(tests_binary)
>> +test_cases_pv: $(tests_pv_img)
>>  
>>  CFLAGS += -std=gnu99
>>  CFLAGS += -ffreestanding
>> @@ -68,8 +75,11 @@ FLATLIBS = $(libcflat)
>>  %.bin: %.elf
>>  	$(OBJCOPY) -O binary  $< $@
>>  
>> +%.pv.img: %.bin $(HOST_KEY_DOCUMENT)
>> +	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
>> +
>>  arch_clean: asm_offsets_clean
>> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
>> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,img} $(TEST_DIR)/.*.d lib/s390x/.*.d
>>  
>>  generated-files = $(asm-offsets)
>>  $(tests:.elf=.o) $(cstart.o) $(cflatobjs): $(generated-files)
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index b307329354f6..6beaca45fb20 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -16,6 +16,8 @@
>>  #			 # a test. The check line can contain multiple files
>>  #			 # to check separated by a space but each check
>>  #			 # parameter needs to be of the form <path>=<value>
>> +# pv_support = 0|1       # Optionally specify whether a test supports the
>> +#                        # execution as a PV guest.
>>  ##############################################################################
>>  
>>  [selftest-setup]
>> @@ -25,62 +27,80 @@ extra_params = -append 'test 123'
>>  
>>  [intercept]
>>  file = intercept.elf
>> +pv_support = 1
> 
> So, let's do this discussion once more:
> Why would we need a opt-in for something which works on all our current
> tests? I'd much rather have a opt-out or just a bail-out when running
> the test like I already implemented for the storage key related tests...
> 
> I don't see any benefit for this right now other than forcing me to add
> another line to this file that was not needed before..
> 

Exactly my thought. I would assume that most tests that properly test
for feature availability should just work?

-- 
Thanks,

David / dhildenb

