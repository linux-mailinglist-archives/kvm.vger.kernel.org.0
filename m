Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EBB33F9EC
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 21:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhCQUYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 16:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbhCQUYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 16:24:13 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684F3C06174A
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 13:24:13 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id f26so4792105ljp.8
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 13:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=UoP5vbXQUCTeXplWQd5+jCv+uXJf29Z8WjosusPDDgE=;
        b=GweKBQvjbvaarn2tbegQAqSVrrwxZZyriSBnxK7nJxSvMMfPTjjfhT4+L77ZKJOQdm
         QXuXdNSLPdQ1uAZVd5PEyYxVatxc1GJbmSCOaUAO2+KB7MBiPY7dpSwBtnLunpZyRrDA
         udVO/97L6QvC9ry+lKzp4ZA6C9uvpR4CfgdCTlauJQ+rL3hqhdDWZM0iR7KH712y4DH4
         7nERTsl/wJjG7vzgOCoXl5HD5nAH2AMOvTOAKwiWLeZK+oPP3E9Ww/Jhn8m9CLG/gu9f
         6PUJ3G5GV75Td2zglfjljGe8k880hJbQrD0S869qBEx+geYA069UmB/2F+WmlmMW9gsg
         APJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UoP5vbXQUCTeXplWQd5+jCv+uXJf29Z8WjosusPDDgE=;
        b=VZBqE3AvRttA4AQJwoDglO96Tvo1NzxVd1AYORYPl7dwC0ss7YySMxmpTRYEiRpxg8
         Fjbdz7RwLvVjZxwcKDu9XZyN/Mb4BTjpEwzr1oOnSSFKcF6nXNwKyEYz4iHPqaYdoYze
         geK00lwetNgvMdbeZoLWh3Qa0Vftk9F/3jkZl/eoW3L/fKQFF9QWwFGZpCx5lrlBi1+h
         cp+iWYS2ZOBxFg6OaFRqNozZfCNkCBFUdhHKgwAqAJV25WZOIi3r6qVyDJYY267CaaJ+
         bNkjyKKw50sHB24U+NbHloZu4t6H3Ps26bQTi2wqYXa0nmiKE691rjpp12utnCOmnHXb
         +7PA==
X-Gm-Message-State: AOAM532bUbn+qCcfEd/FIrJbAxF51HNjVE9upZCpcPuBG8p9yeyOVQeO
        FY74b073PuXiuE/yAsoLaxSuwrWkqbYYUXs8
X-Google-Smtp-Source: ABdhPJz8+tFgU7YLcKX89dJhqHCQ85Aa+5czwRnghd9Meks//33nGpf5aEa+VObpSoQ1OrBWKBgQJQ==
X-Received: by 2002:a2e:864a:: with SMTP id i10mr3200341ljj.467.1616012651753;
        Wed, 17 Mar 2021 13:24:11 -0700 (PDT)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id j18sm3477080lfg.26.2021.03.17.13.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 13:24:10 -0700 (PDT)
Message-ID: <54577b1c3159da9857d1df3ab776df80797b5ddc.camel@gmail.com>
Subject: Re: [RFC PATCH kvm-unit-tests] x86: add ioregionfd fast PIO test
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Wed, 17 Mar 2021 13:23:59 -0700
In-Reply-To: <20210305110403.piqta7jn3bpgfkxs@kamzik.brq.redhat.com>
References: <20210301183319.12370-1-eafanasova@gmail.com>
         <20210305110403.piqta7jn3bpgfkxs@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-03-05 at 12:04 +0100, Andrew Jones wrote:
> Hi Elena,
> 
> I think KVM selftests[1] is perhaps a better test framework for this
> type of test, but I'm not opposed to teaching kvm-unit-tests how to
> do this too. I have some ideas as to how to do it more generally
> though. Please see comments below.
> 
> (If you are interested in trying to do the testing with KVM
> selftests,
>  and would like some suggestions as to how to get started, then feel
>  free to mail me.)
> 
> [1] Linux src: tools/testing/selftests/kvm
> 
> 
> On Mon, Mar 01, 2021 at 09:33:19PM +0300, Elena Afanasova wrote:
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> >  scripts/common.bash   | 12 +++++--
> >  scripts/runtime.bash  |  9 +++++
> >  x86/Makefile.common   |  5 ++-
> >  x86/Makefile.x86_64   |  2 ++
> >  x86/ioregionfd-test.c | 84
> > +++++++++++++++++++++++++++++++++++++++++++
> >  x86/ioregionfd_pio.c  | 24 +++++++++++++
> >  x86/unittests.cfg     |  7 ++++
> >  7 files changed, 140 insertions(+), 3 deletions(-)
> >  create mode 100644 x86/ioregionfd-test.c
> >  create mode 100644 x86/ioregionfd_pio.c
> > 
> > diff --git a/scripts/common.bash b/scripts/common.bash
> > index 7b983f7..d9f8556 100644
> > --- a/scripts/common.bash
> > +++ b/scripts/common.bash
> > @@ -14,6 +14,8 @@ function for_each_unittest()
> >  	local accel
> >  	local timeout
> >  	local rematch
> > +	local helper_cmd
> > +	local fifo
> 
> I'd prefer not to add 'fifo' to the unittests.cfg parameter list, as
> that's specific to this particular "helper_cmd". Also, while in this
> case the helper runs along side the test, a generic helper may need
> to do pre-test and post-test work. So, I think we should follow the
> migration test model and pass the QEMU command line (minus the new
> -device pc-testdev part) to the helper program where it then does
> pre-test stuff (in this case mkfifo), possibly augments the test's
> QEMU command line (in this case with the -device pc-testdev part),
> and runs the test (in parallel with ioregionfd-helper in this case),
> and then does any post-test work (remove the fifos).
> 
> You can write a Bash script that does most of that and which also
> launches ioregionfd-helper (notice, I'm suggesting we rename that
> from iorergionfd-test, as it's not a test, it's a test helper).
> 
> >  
> >  	exec {fd}<"$unittests"
> >  
> > @@ -21,7 +23,7 @@ function for_each_unittest()
> >  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
> >  			rematch=${BASH_REMATCH[1]}
> >  			if [ -n "${testname}" ]; then
> > -				$(arch_cmd) "$cmd" "$testname"
> > "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel"
> > "$timeout"
> > +				$(arch_cmd) "$cmd" "$testname"
> > "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel"
> > "$timeout" "$helper_cmd" "$fifo"
> >  			fi
> >  			testname=$rematch
> >  			smp=1
> > @@ -32,6 +34,8 @@ function for_each_unittest()
> >  			check=""
> >  			accel=""
> >  			timeout=""
> > +			helper_cmd=""
> > +			fifo=""
> >  		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
> >  			kernel=$TEST_DIR/${BASH_REMATCH[1]}
> >  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> > @@ -48,10 +52,14 @@ function for_each_unittest()
> >  			accel=${BASH_REMATCH[1]}
> >  		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
> >  			timeout=${BASH_REMATCH[1]}
> > +		elif [[ $line =~ ^helper_cmd\ *=\ *(.*)$ ]]; then
> > +			helper_cmd=$TEST_DIR/${BASH_REMATCH[1]}
> > +		elif [[ $line =~ ^fifo\ *=\ *(.*)$ ]]; then
> > +			fifo=${BASH_REMATCH[1]}
> >  		fi
> >  	done
> >  	if [ -n "${testname}" ]; then
> > -		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp"
> > "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> > +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp"
> > "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> > "$helper_cmd" "$fifo"
> >  	fi
> >  	exec {fd}<&-
> >  }
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 132389c..ba94ee5 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -81,6 +81,8 @@ function run()
> >      local check="${CHECK:-$7}"
> >      local accel="$8"
> >      local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the
> > default
> > +    local helper_cmd="${10}"
> > +    local fifo="${11}"
> >  
> >      if [ -z "$testname" ]; then
> >          return
> > @@ -139,6 +141,11 @@ function run()
> >          echo $cmdline
> >      fi
> >  
> > +    if [ -n "${helper_cmd}" ] && [ -n "${fifo}" ]; then
> > +        mkfifo $fifo
> > +        $helper_cmd $fifo &
> > +    fi
> > +
> >      # extra_params in the config file may contain backticks that
> > need to be
> >      # expanded, so use eval to start qemu.  Use "> >(foo)" instead
> > of a pipe to
> >      # preserve the exit status.
> > @@ -159,6 +166,8 @@ function run()
> >          print_result "FAIL" $testname "$summary"
> >      fi
> >  
> > +    [ -n "${fifo}" ] && rm -rf $fifo
> > +
> >      return $ret
> >  }
> 
> With the suggestion I'm making I think all the changes above in
> runtime.bash
> can go away, as we can simply do the following instead
> 
> diff --git a/x86/run b/x86/run
> index 8b2425f45640..fdd6121e37ad 100755
> --- a/x86/run
> +++ b/x86/run
> @@ -39,6 +39,6 @@ fi
>  
>  command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none
> -serial stdio $pci_testdev"
>  command+=" -machine accel=$ACCEL -kernel"
> -command="$(timeout_cmd) $command"
> +command="$(timeout_cmd) $(helper_cmd) $command"
>  
>  run_qemu ${command} "$@"
> 
> 
> Assuming we have helper_cmd defined in x86/run some how.
> 
> >  
> > diff --git a/x86/Makefile.common b/x86/Makefile.common
> > index 55f7f28..a5cd1d2 100644
> > --- a/x86/Makefile.common
> > +++ b/x86/Makefile.common
> > @@ -82,6 +82,9 @@ $(TEST_DIR)/hyperv_stimer.elf:
> > $(TEST_DIR)/hyperv.o
> >  
> >  $(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
> >  
> > +$(TEST_DIR)/ioregionfd-test:
> > +	$(CC) -o $@ $(TEST_DIR)/ioregionfd-test.c
> > +
> >  arch_clean:
> > -	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
> > +	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf
> > $(TEST_DIR)/ioregionfd-test \
> >  	$(TEST_DIR)/.*.d lib/x86/.*.d \
> > diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> > index 8134952..1a7a6b1 100644
> > --- a/x86/Makefile.x86_64
> > +++ b/x86/Makefile.x86_64
> > @@ -24,6 +24,8 @@ tests += $(TEST_DIR)/vmware_backdoors.flat
> >  tests += $(TEST_DIR)/rdpru.flat
> >  tests += $(TEST_DIR)/pks.flat
> >  tests += $(TEST_DIR)/pmu_lbr.flat
> > +tests += $(TEST_DIR)/ioregionfd_pio.flat
> > +tests += $(TEST_DIR)/ioregionfd-test
> 
> Please write as
> 
>  tests += $(TEST_DIR)/ioregionfd_pio.flat $(TEST_DIR)/ioregionfd-test
> 
> >  
> >  ifneq ($(fcf_protection_full),)
> >  tests += $(TEST_DIR)/cet.flat
> > diff --git a/x86/ioregionfd-test.c b/x86/ioregionfd-test.c
> > new file mode 100644
> > index 0000000..5ea5e57
> > --- /dev/null
> > +++ b/x86/ioregionfd-test.c
> > @@ -0,0 +1,84 @@
> > +#include <linux/ioregion.h>
> > +#include <string.h>
> > +#include <poll.h>
> > +#include <stdarg.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > +
> > +void err_exit(const char *fmt, ...)
> > +{
> > +	va_list args;
> > +
> > +	va_start(args, fmt);
> > +	vfprintf(stderr, fmt, args);
> > +	va_end(args);
> > +	exit(EXIT_FAILURE);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	struct ioregionfd_cmd cmd;
> > +	struct ioregionfd_resp resp;
> > +	struct pollfd pollfd;
> > +	int read_fd, write_fd = -1;
> > +	unsigned long cdata = 0;
> > +	int ret;
> > +
> > +	if (argc < 2)
> > +		err_exit("Usage: %s <read_fifo> <write_fifo>\n",
> > argv[0]);
> > +
> > +	read_fd = open(argv[1], O_RDONLY);
> > +	if (read_fd < 0)
> > +		err_exit("failed to open read fifo %s\n", argv[1]);
> > +
> > +	if (argc == 3) {
> > +		write_fd = open(argv[2], O_WRONLY);
> > +		if (write_fd < 0) {
> > +			close(read_fd);
> > +			err_exit("failed to open write fifo %s\n",
> > argv[2]);
> > +		}
> > +	}
> > +
> > +	pollfd.fd = read_fd;
> > +	pollfd.events = POLLIN;
> > +
> > +	for (;;) {
> > +		ret = poll(&pollfd, 1, -1);
> > +		if (ret < 0) {
> > +			close(read_fd);
> > +			if (write_fd > 0)
> > +				close(write_fd);
> > +			err_exit("poll\n");
> > +		}
> > +
> > +		if (pollfd.revents & POLLIN) {
> > +			ret = read(read_fd, &cmd, sizeof(cmd));
> > +
> > +			switch (cmd.cmd) {
> > +			case IOREGIONFD_CMD_READ:
> > +				memset(&resp, 0, sizeof(resp));
> > +				memcpy(&resp.data, &cdata, 1 <<
> > cmd.size_exponent);
> > +				ret = write(write_fd, &resp,
> > sizeof(resp));
> > +				break;
> > +			case IOREGIONFD_CMD_WRITE:
> > +				memcpy(&cdata, &cmd.data, 1 <<
> > cmd.size_exponent);
> > +				if (cmd.resp) {
> > +					memset(&resp, 0, sizeof(resp));
> > +					ret = write(write_fd, &resp,
> > sizeof(resp));
> > +				}
> > +				break;
> > +			default:
> > +				break;
> > +			}
> > +		} else
> > +			break;
> > +	}
> > +
> > +	close(read_fd);
> > +	if (write_fd > 0)
> > +		close(write_fd);
> > +
> > +	return 0;
> > +}
> > diff --git a/x86/ioregionfd_pio.c b/x86/ioregionfd_pio.c
> > new file mode 100644
> > index 0000000..eaf8aad
> > --- /dev/null
> > +++ b/x86/ioregionfd_pio.c
> > @@ -0,0 +1,24 @@
> > +#include "x86/vm.h"
> > +
> > +int main(int ac, char **av)
> > +{
> > +	u32 expected = 0x11223344;
> > +	u32 val = 0;
> > +	u32 write_addr = 0x1234;
> 
> Getting this address from the command line would allow us to only
> hard code it in one place, unittests.cfg.
> 
> > +	u32 read_addr = 0x1238;
> > +
> > +	outb(expected, write_addr);
> > +	val = inb(read_addr);
> > +	report(val == (u8)expected, "%x\n", val);
> > +
> > +	outw(expected, write_addr);
> > +	val = inw(read_addr);
> > +	report(val == (u16)expected, "%x\n", val);
> > +
> > +	outl(expected, write_addr);
> > +	val = inl(read_addr);
> > +	report(val == expected, "%x\n", val);
> > +
> > +	return report_summary();
> > +}
> > +
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 0698d15..8001808 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -389,3 +389,10 @@ file = cet.flat
> >  arch = x86_64
> >  smp = 2
> >  extra_params = -enable-kvm -m 2048 -cpu host
> > +
> > +[ioregion-pio]
> > +file = ioregionfd_pio.flat
> > +helper_cmd = ioregionfd-test
> > +fifo = /tmp/test1 /tmp/test2
> > +extra_params = -device pc-
> > testdev,addr=0x1234,size=8,rfifo=/tmp/test2,wfifo=/tmp/test1,pio=tr
> > ue
> 
> If we wrap the QEMU invocation in the helper_cmd, then we can use
> mktemp to
> create our fifo node names. We also can put the address into a
> variable
> that we both pass to the QEMU command line augmentation and to the
> unit
> test through the unit test's command line.
> 
> Thanks,
> drew
> 
Hi Andrew,

Thank you for the feedback and code review! Will rework.

> > +arch = x86_64
> > -- 
> > 2.25.1
> > 

