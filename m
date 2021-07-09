Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E743C25D7
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 16:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhGIOZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 10:25:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229561AbhGIOZm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Jul 2021 10:25:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169EFJvY189128;
        Fri, 9 Jul 2021 10:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Td5OpM0huNaSZooLOaqoUK/0SC/3VJ1AE8pgMDfztek=;
 b=JmZ6lORwz93U5znoI0kfOaKVWO/DNNKysKEetY0EZZq9fGGsw6gf6bKCranblURWHVc1
 mm4PYYK/gyf5fmdyjYZWbURdGowfY/pAFiRrnVDlGMDzjEq12sqeMPsHsQJ9hdwUc+b3
 dpQyewT5wU2epO2zVvwIjoFDBd8TvXOw88z1yt8lSXtpoVDJMaGf6PQ6Xw2bavuKTNjg
 uya5NksV7luYSNMVu2c79u/D1HesfNoFZYIZv9W8QEgyRo/H7pF6MCJDnsnT/pKa/Hjt
 025B0bEnZlFyguKSd31Toy4m67oYQ3MGk88M+JdzjrRIIJoWP6FTqCLrXKdtRWdxJrmy bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39pjhehddf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 10:22:58 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 169EFgvj190111;
        Fri, 9 Jul 2021 10:22:57 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39pjhehdcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 10:22:57 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 169EHc3i007383;
        Fri, 9 Jul 2021 14:22:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 39jfh8hf59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jul 2021 14:22:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 169EKtQ435782946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Jul 2021 14:20:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5418FA405B;
        Fri,  9 Jul 2021 14:22:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE6D7A4057;
        Fri,  9 Jul 2021 14:22:50 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.8.8])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Jul 2021 14:22:50 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception test
To:     Cornelia Huck <cohuck@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115459.372749-1-scgl@linux.ibm.com>
 <87v95jet9d.fsf@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <e5a5fa4a-c5c4-e3f8-3229-9c8e70dffb45@linux.vnet.ibm.com>
Date:   Fri, 9 Jul 2021 16:22:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87v95jet9d.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: z4bFkgCzfwK2JQQKNqKCiII8dZXEVWJy
X-Proofpoint-GUID: YnNP0I0vONsWehfzmuh9hNbUgasgkqDh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-09_09:2021-07-09,2021-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107090070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/9/21 11:22 AM, Cornelia Huck wrote:
> On Tue, Jul 06 2021, Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Generate specification exceptions and check that they occur.
>> Also generate specification exceptions during a transaction,
>> which results in another interruption code.
>> With the iterations argument one can check if specification
>> exception interpretation occurs, e.g. by using a high value and
>> checking that the debugfs counters are substantially lower.
>> The argument is also useful for estimating the performance benefit
>> of interpretation.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>  s390x/Makefile           |   1 +
>>  lib/s390x/asm/arch_def.h |   1 +
>>  s390x/spec_ex.c          | 344 +++++++++++++++++++++++++++++++++++++++
>>  s390x/unittests.cfg      |   3 +
>>  4 files changed, 349 insertions(+)
>>  create mode 100644 s390x/spec_ex.c
> 
> (...)
> 
>> +static void lpsw(uint64_t psw)
> 
> Maybe call this load_psw(), as you do a bit more than a simple lpsw?

[...]

> The indentation looks a bit funny here.

[...]

> Here as well.

Ok, will fix.
> 
>> +}
> 
> (...)
> 
>> +#define report_info_if(cond, fmt, ...)			\
>> +	do {						\
>> +		if (cond) {				\
>> +			report_info(fmt, ##__VA_ARGS__);\
>> +		}					\
>> +	} while (0)
> 
> I'm wondering whether such a wrapper function could be generally useful.
> 

I've found 9 occurrences with:
find . -type f \( -name "*.c" -o -name "*.h" \) -exec awk '/if\s*\(.*/{i=2;f=$0} /report_info/ && i>0{print FILENAME, NR-1 ":" f;r=4} r>1{print FILENAME, NR ":" $0;r--} r==1{print "--";r=0} {i--}' '{}' \;

./lib/s390x/css_lib.c 177:      if (cc) {
./lib/s390x/css_lib.c 178:              report_info("stsch: updating sch %08x failed with cc=%d",
./lib/s390x/css_lib.c 179:                          schid, cc);
./lib/s390x/css_lib.c 180:              return false;
--
./lib/s390x/css_lib.c 183:      if (!(pmcw->flags & PMCW_ENABLE)) {
./lib/s390x/css_lib.c 184:              report_info("stsch: sch %08x not enabled", schid);
./lib/s390x/css_lib.c 185:              return false;
./lib/s390x/css_lib.c 186:      }
--
./lib/s390x/css_lib.c 207:      if (cc) {
./lib/s390x/css_lib.c 208:              report_info("stsch: sch %08x failed with cc=%d", schid, cc);
./lib/s390x/css_lib.c 209:              return cc;
./lib/s390x/css_lib.c 210:      }
--
./lib/s390x/css_lib.c 213:      if ((pmcw->flags & (PMCW_ISC_MASK | PMCW_ENABLE)) == flags) {
./lib/s390x/css_lib.c 214:              report_info("stsch: sch %08x already enabled", schid);
./lib/s390x/css_lib.c 215:              return 0;
./lib/s390x/css_lib.c 216:      }
--
./lib/s390x/css_lib.c 269:      if (cc) {
./lib/s390x/css_lib.c 270:              report_info("stsch: sch %08x failed with cc=%d", schid, cc);
./lib/s390x/css_lib.c 271:              return false;
./lib/s390x/css_lib.c 272:      }
--
./lib/s390x/css_lib.c 305:      if (cc) {
./lib/s390x/css_lib.c 306:              report_info("stsch: updating sch %08x failed with cc=%d",
./lib/s390x/css_lib.c 307:                          schid, cc);
./lib/s390x/css_lib.c 308:              return false;
--
./lib/s390x/css_lib.c 466:      if (irb.scsw.sch_stat & ~SCSW_SCHS_IL) {
./lib/s390x/css_lib.c 467:              report_info("Unexpected Subch. status %02x", irb.scsw.sch_stat);
./lib/s390x/css_lib.c 468:              ret = -1;
./lib/s390x/css_lib.c 469:              goto end;
--
./s390x/sclp.c 80:      if (res) {
./s390x/sclp.c 81:              report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd, addr, res);
./s390x/sclp.c 82:              return false;
./s390x/sclp.c 83:      }
--
./s390x/sclp.c 86:      if (!((1ULL << pgm) & exp_pgm)) {
./s390x/sclp.c 87:              report_info("First failure at addr %p, buf_len %d, cmd %#x, pgm code %d",
./s390x/sclp.c 88:                              addr, buf_len, cmd, pgm);
./s390x/sclp.c 89:              return false;
--
./s390x/sclp.c 92:      if (exp_rc && exp_rc != h->response_code) {
./s390x/sclp.c 93:              report_info("First failure at addr %p, buf_len %d, cmd %#x, resp code %#x",
./s390x/sclp.c 94:                              addr, buf_len, cmd, h->response_code);
./s390x/sclp.c 95:              return false;
--
./s390x/css.c 105:      if (ret < 0) {
./s390x/css.c 106:              report_info("no valid residual count");
./s390x/css.c 107:      } else if (ret != 0) {
./s390x/css.c 108:              len = sizeof(*senseid) - ret;
--
./s390x/css.c 112:              } else if (ret && len)
./s390x/css.c 113:                      report_info("transferred a shorter length: %d", len);
./s390x/css.c 114:      }
./s390x/css.c 115:
--
./s390x/css.c 153:      if (css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK))
./s390x/css.c 154:              report_info("Extended measurement block available");
./s390x/css.c 155:
./s390x/css.c 156:      /* bits 59-63 of MB address must be 0  if MBU is defined */
--
./arm/psci.c 119:               } else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
./arm/psci.c 120:                       report_info("unexpected cpu_on return value: caller=CPU%d, ret=%d", cpu, cpu_on_ret[cpu]);
./arm/psci.c 121:                       failed = true;
./arm/psci.c 122:               }
--
./arm/psci.c 125:       if (ret_success != 1) {
./arm/psci.c 126:               report_info("got %d CPU_ON success", ret_success);
./arm/psci.c 127:               failed = true;
./arm/psci.c 128:       }
--
./arm/pmu.c 236:        if (!supported && warn)
./arm/pmu.c 237:                report_info("event 0x%x is not supported", n);
./arm/pmu.c 238:        return supported;
./arm/pmu.c 239:}
--
./arm/cache.c 115:      if (dcache_clean)
./arm/cache.c 116:              report_info("dcache clean to PoU required");
./arm/cache.c 117:      if (icache_inval)
./arm/cache.c 117:      if (icache_inval)
./arm/cache.c 118:              report_info("icache invalidation to PoU required");
./arm/cache.c 119:
./arm/cache.c 120:      check_code_generation(dcache_clean, icache_inval);
--
./arm/pl031.c 193:      if (!irq_triggered) {
./arm/pl031.c 194:              report_info("  RTC RIS: %"PRIx32, readl(&pl031->ris));
./arm/pl031.c 195:              report_info("  RTC MIS: %"PRIx32, readl(&pl031->mis));
./arm/pl031.c 196:              report_info("  RTC IMSC: %"PRIx32, readl(&pl031->imsc));
--
./arm/gic.c 84:                 if (i)
./arm/gic.c 85:                         report_info("interrupts took more than %d ms", i * 100);
./arm/gic.c 86:                 /* Wait for unexpected interrupts to fire */
./arm/gic.c 87:                 mdelay(100);
--
./arm/gic.c 115:                if (has_gicv2 && irq_sender[cpu] != sender) {
./arm/gic.c 116:                        report_info("cpu%d received IPI from wrong sender %d",
./arm/gic.c 117:                                        cpu, irq_sender[cpu]);
./arm/gic.c 118:                        pass = false;
--
./arm/gic.c 121:                if (irq_number[cpu] != irqnum) {
./arm/gic.c 122:                        report_info("cpu%d received wrong irq %d",
./arm/gic.c 123:                                        cpu, irq_number[cpu]);
./arm/gic.c 124:                        pass = false;
--
./arm/gic.c 128:        if (missing || extra || unexpected) {
./arm/gic.c 129:                report_info("ACKS: missing=%d extra=%d unexpected=%d",
./arm/gic.c 130:                                missing, extra, unexpected);
./arm/gic.c 131:                pass = false;
--
./arm/gic.c 142:                if (spurious[cpu])
./arm/gic.c 143:                        report_info("WARN: cpu%d got %d spurious interrupts",
./arm/gic.c 144:                                cpu, spurious[cpu]);
./arm/gic.c 145:        }
--
./arm/gic.c 194:                if (acked[i] != expected[i]) {
./arm/gic.c 195:                        report_info("expected %d LPIs on PE #%d, %d observed",
./arm/gic.c 196:                                    expected[i], i, acked[i]);
./arm/gic.c 197:                        pass = false;
--
./arm/gic.c 421:        if (!res)
./arm/gic.c 422:                report_info("byte 1 of 0x%08"PRIx32" => 0x%02"PRIx32, pattern & mask, reg);
./arm/gic.c 423:
./arm/gic.c 424:        pattern = REPLACE_BYTE(pattern, 2, 0x1f);
--
./arm/gic.c 429:        if (!res)
./arm/gic.c 430:                report_info("writing 0x%02"PRIx32" into bytes 2 => 0x%08"PRIx32,
./arm/gic.c 431:                            BYTE(pattern, 2), reg);
./arm/gic.c 432:}
--
./arm/gic.c 519:        if (reg != (pattern & cpu_mask))
./arm/gic.c 520:                report_info("writing %08"PRIx32" reads back as %08"PRIx32,
./arm/gic.c 521:                            pattern & cpu_mask, reg);
./arm/gic.c 522:
--
./x86/vmx_tests.c 4733: if (!(ctrl_cpu_rev[0].clr & CPU_NMI_WINDOW)) {
./x86/vmx_tests.c 4734:         report_info("NMI-window exiting is not supported, skipping...");
./x86/vmx_tests.c 4735:         goto done;
./x86/vmx_tests.c 4736: }
--
./x86/vmx_tests.c 4841:                 if (un_cache) {
./x86/vmx_tests.c 4842:                         report_info("EPT paging structure memory-type is Un-cacheable\n");
./x86/vmx_tests.c 4843:                         ctrl = true;
./x86/vmx_tests.c 4844:                 } else {
--
./x86/vmx_tests.c 4848:                 if (wr_bk) {
./x86/vmx_tests.c 4849:                         report_info("EPT paging structure memory-type is Write-back\n");
./x86/vmx_tests.c 4850:                         ctrl = true;
./x86/vmx_tests.c 4851:                 } else {
--
./x86/vmx_tests.c 4899: if (msr & EPT_CAP_AD_FLAG) {
./x86/vmx_tests.c 4900:         report_info("Processor supports accessed and dirty flag");
./x86/vmx_tests.c 4901:         eptp &= ~EPTP_AD_FLAG;
./x86/vmx_tests.c 4902:         test_eptp_ad_bit(eptp, true);
--
