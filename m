Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4AC19A065
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 23:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgCaVCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 17:02:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27294 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727937AbgCaVCs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 17:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585688567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=evPqw0BJGBHuCQCL5T4N0et8BiAo9jpJbZ01jOkBDm0=;
        b=GwjdDSk5st09KpCz5GEz4VC518vQI7+pUpGyD4XGdr2ON+32y6Ny45SITiTzT1N56MZT5B
        fFyJtwnjYDw9QPZQQU6MK4b31wF8bJLJDhT7OSrzSQpb4aRt89+ErbP4oXHkomc8alJiN9
        87kleKaN2B0Wq/dXMm2VYeckJw3aAWA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-7TTdgZEvO1ullh1oJOBCTw-1; Tue, 31 Mar 2020 17:02:44 -0400
X-MC-Unique: 7TTdgZEvO1ullh1oJOBCTw-1
Received: by mail-wm1-f70.google.com with SMTP id p18so1551815wmk.9
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 14:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=evPqw0BJGBHuCQCL5T4N0et8BiAo9jpJbZ01jOkBDm0=;
        b=giiVcreancFf0JSzoMXBiiwMRz4WujvVddqPyYErSM/+c0tCopgoh5SOOawZ+b/kMn
         97Ro8DPdagne1nabOkCYm+qafJUM/QRdCwxSrA31O8lDEenTEB+vpFr5y3n2DcdULeVX
         QJPf1/orr6IIrmHLbX1wkxFSsH6u3rezgoECTRjxKKu3n3DMKnktA6LCp/Eg679Y+rTq
         EUg4Jb60mOnpeBUw38rRHHEMNO2wxK8zNFpwnVKYwhC+sQn7nMpXCLRalXo4PX1H9Tju
         3TNbjg7tiCayX/gVTATFSURdmqQlKdTovOeWBOFdYgmgF1Q3ieVER6X3/R3ofN2vw4dd
         yWUg==
X-Gm-Message-State: AGi0PubK57zqWYzD/hAL/oOcFUlCsWJlqEMypU4WeCMJLgwlWCtXr8of
        aWAkWXik7V1Pp6TKBRpw+Dvid/TOE7XcaTRvh2eg1ey+2TvehPP0d1Mxe1N8k7Giym7sh+8KdTp
        by2RpfDSv5E1V
X-Received: by 2002:a1c:2e10:: with SMTP id u16mr682495wmu.143.1585688562733;
        Tue, 31 Mar 2020 14:02:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypIooK0PRHXKONQGWQahd0h26HD8mEBMSn4OL4ZdopSUPmYtG+faJNkpTNfQf20UcSWa7iPUMA==
X-Received: by 2002:a1c:2e10:: with SMTP id u16mr682474wmu.143.1585688562405;
        Tue, 31 Mar 2020 14:02:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id t81sm5269372wmb.15.2020.03.31.14.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 14:02:41 -0700 (PDT)
Subject: Re: [PATCH 2/3] tools/kvm_stat: Add command line switch '-L' to log
 to file
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
References: <20200331200042.2026-1-raspl@linux.ibm.com>
 <20200331200042.2026-3-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fbc8948f-1d68-62b7-1bfb-08a89ae8e01e@redhat.com>
Date:   Tue, 31 Mar 2020 23:02:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200331200042.2026-3-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/20 22:00, Stefan Raspl wrote:
> From: Stefan Raspl <raspl@de.ibm.com>
> 
> To integrate with logrotate, we have a signal handler that will re-open
> the logfile.
> Assuming we have a systemd unit file with
>      ExecStart=kvm_stat -dtc -s 10 -L /var/log/kvm_stat.csv
>      ExecReload=/bin/kill -HUP $MAINPID
> and a logrotate config featuring
>      postrotate
>         /bin/systemctl restart kvm_stat.service

Does reload work too?

Regarding the code, I only have a few nits.


> +            f.write(frmt.get_banner())
> +            f.write('\n')
> +        else:
> +            print(frmt.get_banner())

What about

      print(frmt.get_banner(), file=f or sys.stdout)

> +
> +    def do_statline(opts):
> +        statline = frmt.get_statline(keys, stats.get())
> +        if len(statline) == 0:
> +            return False
> +        statline = datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline
> +        if opts.log_to_file:
> +            f.write(statline)
> +            f.write('\n')
> +        else:
> +            print(statline)

... and likewise here?  (

>  
> +        return True
> +
> +    do_banner(opts)
> +    banner_printed = True
>      while True:
>          try:
>              time.sleep(opts.set_delay)
> -            if line % banner_repeat == 0 and not banner_printed:
> -                print(frmt.get_banner())
> +            if signal_received:
> +                banner_printed = True
> +                line = 0
> +                f.close()
> +                do_banner(opts)
> +                signal_received = False
> +            if (line % banner_repeat == 0 and not banner_printed and
> +                not (opts.log_to_file and isinstance(frmt, CSVFormat))):
> +                do_banner(opts)
>                  banner_printed = True
> -            statline = frmt.get_statline(keys, stats.get())
> -            if len(statline) == 0:
> +            if not do_statline(opts):
>                  continue
> -            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)
>              line += 1
>              banner_printed = False
>          except KeyboardInterrupt:
>              break
>  
> +    if opts.log_to_file:
> +        f.close()

"if f:"?

> +
> +
> +def handle_signal(sig, frame):
> +    global signal_received
> +
> +    signal_received = True
> +
> +    return
> +
>  
>  def is_delay_valid(delay):
>      """Verify delay is in valid value range."""
> @@ -1652,6 +1703,10 @@ Press any other key to refresh statistics immediately.
>                             default=False,
>                             help='run in logging mode (like vmstat)',
>                             )
> +    argparser.add_argument('-L', '--log-to-file',
> +                           type=str,
> +                           help="like '--log', but logging to a file"
> +                           )
>      argparser.add_argument('-p', '--pid',
>                             type=int,
>                             default=0,
> @@ -1675,9 +1730,9 @@ Press any other key to refresh statistics immediately.
>                             help='omit records with all zeros in logging mode',
>                             )
>      options = argparser.parse_args()
> -    if options.csv and not options.log:
> +    if options.csv and not (options.log or options.log_to_file):
>          sys.exit('Error: Option -c/--csv requires -l/--log')

"requires -l/-L"?

> -    if options.skip_zero_records and not options.log:
> +    if options.skip_zero_records and not (options.log or options.log_to_file):
>          sys.exit('Error: Option -z/--skip-zero-records requires -l/--log')

Likewise.

>      try:
>          # verify that we were passed a valid regex up front
> @@ -1758,7 +1813,9 @@ def main():
>          sys.stdout.write('  ' + '\n  '.join(sorted(set(event_list))) + '\n')
>          sys.exit(0)
>  
> -    if options.log:
> +    if options.log or options.log_to_file:
> +        if options.log_to_file:
> +            signal.signal(signal.SIGHUP, handle_signal)
>          keys = sorted(stats.get().keys())
>          if options.csv:
>              frmt = CSVFormat(keys, options.skip_zero_records)
> diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
> index 24296dccc00a..de7c4a2497f9 100644
> --- a/tools/kvm/kvm_stat/kvm_stat.txt
> +++ b/tools/kvm/kvm_stat/kvm_stat.txt
> @@ -92,6 +92,11 @@ OPTIONS
>  --log::
>          run in logging mode (like vmstat)
>  
> +
> +-L::
> +--log-to-file::
> +        like '--log', but logging to a file

-L<file>:: / --log-to-file=<file>

> +
>  -p<pid>::
>  --pid=<pid>::
>  	limit statistics to one virtual machine (pid)
> 

