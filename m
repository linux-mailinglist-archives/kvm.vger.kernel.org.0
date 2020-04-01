Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C9619AC33
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 14:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbgDAM74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 08:59:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732370AbgDAM74 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 08:59:56 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031CcYDm070300
        for <kvm@vger.kernel.org>; Wed, 1 Apr 2020 08:59:55 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3020wetska-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 08:59:54 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Wed, 1 Apr 2020 13:59:38 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 13:59:35 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 031CxmJs50987236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 12:59:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D348BA406D;
        Wed,  1 Apr 2020 12:59:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACE5CA4065;
        Wed,  1 Apr 2020 12:59:48 +0000 (GMT)
Received: from [9.145.48.113] (unknown [9.145.48.113])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 12:59:48 +0000 (GMT)
Subject: Re: [PATCH 2/3] tools/kvm_stat: Add command line switch '-L' to log
 to file
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200331200042.2026-1-raspl@linux.ibm.com>
 <20200331200042.2026-3-raspl@linux.ibm.com>
 <fbc8948f-1d68-62b7-1bfb-08a89ae8e01e@redhat.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
Date:   Wed, 1 Apr 2020 14:59:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fbc8948f-1d68-62b7-1bfb-08a89ae8e01e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040112-4275-0000-0000-000003B79B9B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040112-4276-0000-0000-000038CCEE83
Message-Id: <a946ac56-489b-6eb2-d162-80247190c500@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_01:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004010109
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-31 23:02, Paolo Bonzini wrote:
> On 31/03/20 22:00, Stefan Raspl wrote:
>> From: Stefan Raspl <raspl@de.ibm.com>
>>
>> To integrate with logrotate, we have a signal handler that will re-open
>> the logfile.
>> Assuming we have a systemd unit file with
>>      ExecStart=kvm_stat -dtc -s 10 -L /var/log/kvm_stat.csv
>>      ExecReload=/bin/kill -HUP $MAINPID
>> and a logrotate config featuring
>>      postrotate
>>         /bin/systemctl restart kvm_stat.service
> 
> Does reload work too?

Reload and restart work fine - any specific concerns or areas to look for?


> Regarding the code, I only have a few nits.
> 
> 
>> +            f.write(frmt.get_banner())
>> +            f.write('\n')
>> +        else:
>> +            print(frmt.get_banner())
> 
> What about
> 
>       print(frmt.get_banner(), file=f or sys.stdout)

Yup, thx!


>> +
>> +    def do_statline(opts):
>> +        statline = frmt.get_statline(keys, stats.get())
>> +        if len(statline) == 0:
>> +            return False
>> +        statline = datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline
>> +        if opts.log_to_file:
>> +            f.write(statline)
>> +            f.write('\n')
>> +        else:
>> +            print(statline)
> 
> ... and likewise here?  (

Sure


>>  
>> +        return True
>> +
>> +    do_banner(opts)
>> +    banner_printed = True
>>      while True:
>>          try:
>>              time.sleep(opts.set_delay)
>> -            if line % banner_repeat == 0 and not banner_printed:
>> -                print(frmt.get_banner())
>> +            if signal_received:
>> +                banner_printed = True
>> +                line = 0
>> +                f.close()
>> +                do_banner(opts)
>> +                signal_received = False
>> +            if (line % banner_repeat == 0 and not banner_printed and
>> +                not (opts.log_to_file and isinstance(frmt, CSVFormat))):
>> +                do_banner(opts)
>>                  banner_printed = True
>> -            statline = frmt.get_statline(keys, stats.get())
>> -            if len(statline) == 0:
>> +            if not do_statline(opts):
>>                  continue
>> -            print(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + statline)
>>              line += 1
>>              banner_printed = False
>>          except KeyboardInterrupt:
>>              break
>>  
>> +    if opts.log_to_file:
>> +        f.close()
> 
> "if f:"?

I'd argue the former is a lot more telling/easier to read - one of the downsides
of using extremely short variable names like 'f'.


>> +
>> +
>> +def handle_signal(sig, frame):
>> +    global signal_received
>> +
>> +    signal_received = True
>> +
>> +    return
>> +
>>  
>>  def is_delay_valid(delay):
>>      """Verify delay is in valid value range."""
>> @@ -1652,6 +1703,10 @@ Press any other key to refresh statistics immediately.
>>                             default=False,
>>                             help='run in logging mode (like vmstat)',
>>                             )
>> +    argparser.add_argument('-L', '--log-to-file',
>> +                           type=str,
>> +                           help="like '--log', but logging to a file"
>> +                           )
>>      argparser.add_argument('-p', '--pid',
>>                             type=int,
>>                             default=0,
>> @@ -1675,9 +1730,9 @@ Press any other key to refresh statistics immediately.
>>                             help='omit records with all zeros in logging mode',
>>                             )
>>      options = argparser.parse_args()
>> -    if options.csv and not options.log:
>> +    if options.csv and not (options.log or options.log_to_file):
>>          sys.exit('Error: Option -c/--csv requires -l/--log')
> 
> "requires -l/-L"?

Yes!


>> -    if options.skip_zero_records and not options.log:
>> +    if options.skip_zero_records and not (options.log or options.log_to_file):
>>          sys.exit('Error: Option -z/--skip-zero-records requires -l/--log')
> 
> Likewise.

Of course.


>>      try:
>>          # verify that we were passed a valid regex up front
>> @@ -1758,7 +1813,9 @@ def main():
>>          sys.stdout.write('  ' + '\n  '.join(sorted(set(event_list))) + '\n')
>>          sys.exit(0)
>>  
>> -    if options.log:
>> +    if options.log or options.log_to_file:
>> +        if options.log_to_file:
>> +            signal.signal(signal.SIGHUP, handle_signal)
>>          keys = sorted(stats.get().keys())
>>          if options.csv:
>>              frmt = CSVFormat(keys, options.skip_zero_records)
>> diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
>> index 24296dccc00a..de7c4a2497f9 100644
>> --- a/tools/kvm/kvm_stat/kvm_stat.txt
>> +++ b/tools/kvm/kvm_stat/kvm_stat.txt
>> @@ -92,6 +92,11 @@ OPTIONS
>>  --log::
>>          run in logging mode (like vmstat)
>>  
>> +
>> +-L::
>> +--log-to-file::
>> +        like '--log', but logging to a file
> 
> -L<file>:: / --log-to-file=<file>

Argh...

Ciao,
Stefan

