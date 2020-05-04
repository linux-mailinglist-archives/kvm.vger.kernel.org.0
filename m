Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3081C3525
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 10:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgEDI72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 04:59:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbgEDI72 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 04:59:28 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0448WimJ055382;
        Mon, 4 May 2020 04:59:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d3jxxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 04:59:26 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0448d9AU071053;
        Mon, 4 May 2020 04:59:26 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5d3jxwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 04:59:25 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0448t9Oe000741;
        Mon, 4 May 2020 08:59:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5mcha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:59:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0448xKY817039454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 08:59:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B420DA4055;
        Mon,  4 May 2020 08:59:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A056BA404D;
        Mon,  4 May 2020 08:59:19 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.161.129])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 08:59:19 +0000 (GMT)
Subject: Re: s390 KVM warning in handle_pqap()
To:     Qian Cai <cailca@icloud.com>, Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <ED53E46F-EF53-46F6-B88E-2035965AB20C@icloud.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 xsFNBE6cPPgBEAC2VpALY0UJjGmgAmavkL/iAdqul2/F9ONz42K6NrwmT+SI9CylKHIX+fdf
 J34pLNJDmDVEdeb+brtpwC9JEZOLVE0nb+SR83CsAINJYKG3V1b3Kfs0hydseYKsBYqJTN2j
 CmUXDYq9J7uOyQQ7TNVoQejmpp5ifR4EzwIFfmYDekxRVZDJygD0wL/EzUr8Je3/j548NLyL
 4Uhv6CIPf3TY3/aLVKXdxz/ntbLgMcfZsDoHgDk3lY3r1iwbWwEM2+eYRdSZaR4VD+JRD7p8
 0FBadNwWnBce1fmQp3EklodGi5y7TNZ/CKdJ+jRPAAnw7SINhSd7PhJMruDAJaUlbYaIm23A
 +82g+IGe4z9tRGQ9TAflezVMhT5J3ccu6cpIjjvwDlbxucSmtVi5VtPAMTLmfjYp7VY2Tgr+
 T92v7+V96jAfE3Zy2nq52e8RDdUo/F6faxcumdl+aLhhKLXgrozpoe2nL0Nyc2uqFjkjwXXI
 OBQiaqGeWtxeKJP+O8MIpjyGuHUGzvjNx5S/592TQO3phpT5IFWfMgbu4OreZ9yekDhf7Cvn
 /fkYsiLDz9W6Clihd/xlpm79+jlhm4E3xBPiQOPCZowmHjx57mXVAypOP2Eu+i2nyQrkapaY
 IdisDQfWPdNeHNOiPnPS3+GhVlPcqSJAIWnuO7Ofw1ZVOyg/jwARAQABzUNDaHJpc3RpYW4g
 Qm9ybnRyYWVnZXIgKDJuZCBJQk0gYWRkcmVzcykgPGJvcm50cmFlZ2VyQGxpbnV4LmlibS5j
 b20+wsF5BBMBAgAjBQJdP/hMAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQEXu8
 gLWmHHy/pA/+JHjpEnd01A0CCyfVnb5fmcOlQ0LdmoKWLWPvU840q65HycCBFTt6V62cDljB
 kXFFxMNA4y/2wqU0H5/CiL963y3gWIiJsZa4ent+KrHl5GK1nIgbbesfJyA7JqlB0w/E/SuY
 NRQwIWOo/uEvOgXnk/7+rtvBzNaPGoGiiV1LZzeaxBVWrqLtmdi1iulW/0X/AlQPuF9dD1Px
 hx+0mPjZ8ClLpdSp5d0yfpwgHtM1B7KMuQPQZGFKMXXTUd3ceBUGGczsgIMipZWJukqMJiJj
 QIMH0IN7XYErEnhf0GCxJ3xAn/J7iFpPFv8sFZTvukntJXSUssONnwiKuld6ttUaFhSuSoQg
 OFYR5v7pOfinM0FcScPKTkrRsB5iUvpdthLq5qgwdQjmyINt3cb+5aSvBX2nNN135oGOtlb5
 tf4dh00kUR8XFHRrFxXx4Dbaw4PKgV3QLIHKEENlqnthH5t0tahDygQPnSucuXbVQEcDZaL9
 WgJqlRAAj0pG8M6JNU5+2ftTFXoTcoIUbb0KTOibaO9zHVeGegwAvPLLNlKHiHXcgLX1tkjC
 DrvE2Z0e2/4q7wgZgn1kbvz7ZHQZB76OM2mjkFu7QNHlRJ2VXJA8tMXyTgBX6kq1cYMmd/Hl
 OhFrAU3QO1SjCsXA2CDk9MM1471mYB3CTXQuKzXckJnxHkHOwU0ETpw8+AEQAJjyNXvMQdJN
 t07BIPDtbAQk15FfB0hKuyZVs+0lsjPKBZCamAAexNRk11eVGXK/YrqwjChkk60rt3q5i42u
 PpNMO9aS8cLPOfVft89Y654Qd3Rs1WRFIQq9xLjdLfHh0i0jMq5Ty+aiddSXpZ7oU6E+ud+X
 Czs3k5RAnOdW6eV3+v10sUjEGiFNZwzN9Udd6PfKET0J70qjnpY3NuWn5Sp1ZEn6lkq2Zm+G
 9G3FlBRVClT30OWeiRHCYB6e6j1x1u/rSU4JiNYjPwSJA8EPKnt1s/Eeq37qXXvk+9DYiHdT
 PcOa3aNCSbIygD3jyjkg6EV9ZLHibE2R/PMMid9FrqhKh/cwcYn9FrT0FE48/2IBW5mfDpAd
 YvpawQlRz3XJr2rYZJwMUm1y+49+1ZmDclaF3s9dcz2JvuywNq78z/VsUfGz4Sbxy4ShpNpG
 REojRcz/xOK+FqNuBk+HoWKw6OxgRzfNleDvScVmbY6cQQZfGx/T7xlgZjl5Mu/2z+ofeoxb
 vWWM1YCJAT91GFvj29Wvm8OAPN/+SJj8LQazd9uGzVMTz6lFjVtH7YkeW/NZrP6znAwv5P1a
 DdQfiB5F63AX++NlTiyA+GD/ggfRl68LheSskOcxDwgI5TqmaKtX1/8RkrLpnzO3evzkfJb1
 D5qh3wM1t7PZ+JWTluSX8W25ABEBAAHCwV8EGAECAAkFAk6cPPgCGwwACgkQEXu8gLWmHHz8
 2w//VjRlX+tKF3szc0lQi4X0t+pf88uIsvR/a1GRZpppQbn1jgE44hgF559K6/yYemcvTR7r
 6Xt7cjWGS4wfaR0+pkWV+2dbw8Xi4DI07/fN00NoVEpYUUnOnupBgychtVpxkGqsplJZQpng
 v6fauZtyEcUK3dLJH3TdVQDLbUcL4qZpzHbsuUnTWsmNmG4Vi0NsEt1xyd/Wuw+0kM/oFEH1
 4BN6X9xZcG8GYUbVUd8+bmio8ao8m0tzo4pseDZFo4ncDmlFWU6hHnAVfkAs4tqA6/fl7RLN
 JuWBiOL/mP5B6HDQT9JsnaRdzqF73FnU2+WrZPjinHPLeE74istVgjbowvsgUqtzjPIG5pOj
 cAsKoR0M1womzJVRfYauWhYiW/KeECklci4TPBDNx7YhahSUlexfoftltJA8swRshNA/M90/
 i9zDo9ySSZHwsGxG06ZOH5/MzG6HpLja7g8NTgA0TD5YaFm/oOnsQVsf2DeAGPS2xNirmknD
 jaqYefx7yQ7FJXXETd2uVURiDeNEFhVZWb5CiBJM5c6qQMhmkS4VyT7/+raaEGgkEKEgHOWf
 ZDP8BHfXtszHqI3Fo1F4IKFo/AP8GOFFxMRgbvlAs8z/+rEEaQYjxYJqj08raw6P4LFBqozr
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <57992d1f-434e-3900-1958-542cd830aad1@de.ibm.com>
Date:   Mon, 4 May 2020 10:59:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <ED53E46F-EF53-46F6-B88E-2035965AB20C@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_04:2020-05-01,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=641 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02.05.20 04:38, Qian Cai wrote:
> This line,
> 
> if (WARN_ON_ONCE(fc != 0x03))
> 
> qemu-kvm-2.12.0-99.module+el8.2.0+5827+8c39933c with this kernel config,
> 
> https://raw.githubusercontent.com/cailca/linux-mm/master/s390.config
> 
> # /usr/libexec/qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host -smp 2 -m 2G -hda ubuntu-18.04-server-cloudimg.qcow2 -cdrom ubuntu-18.04-server-cloudimg.iso -nic user,hostfwd=tcp::2222-:22 -nographic
> 
> 00: [  424.578896] WARNING: CPU: 0 PID: 1533 at arch/s390/kvm/priv.c:632 handle_
> 00: pqap+0x2b6/0x468 [kvm]                                                      
> 00: [  424.578934] Modules linked in: kvm ip_tables x_tables xfs dasd_fba_mod da
> 00: sd_eckd_mod dm_mirror dm_region_hash dm_log dm_mod                          
> 00: [  424.579026] CPU: 0 PID: 1533 Comm: qemu-kvm Not tainted 5.7.0-rc3-next-20
> 00: 200501 #2                                                                   
> 00: [  424.579064] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)                 

You run nested unter z/VM (under LPAR). So it looks like z/VM behaves different to
LPAR regarding the interception of the PQAP instruction. 
Tony, can you talk to your z/VM colleagues about this? I guess we might need to 
remove the WARN_ON_ONCE(fc != 0x03) and simply return EOPNOTSUPP if our assumption
is not right. I guess z/VM has its ECA field set to 0 so the effective ECA field
is also 0.



> 00: [  424.579101] Krnl PSW : 0704d00180000000 000003ff80440dc2 (handle_pqap+0x2
> 00: ba/0x468 [kvm])                                                             
> 00: [  424.579239]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0
> 00:  RI:0 EA:3                                                                  
> 00: [  424.579282] Krnl GPRS: 0000000000000000 0000030000000000 0000030000000000
> 00:  00000000e1ca6148                                                           
> 00: [  424.579320]            0000030000000000 000003ff80440c14 0000000000000000
> 00:  00000000822e8520                                                           
> 00: [  424.579359]            00000000e1ca6000 000000009c79a000 00000000822e8008
> 00:  0000007c00877e70                                                           
> 00: [  424.579399]            000003ff803f5000 000003ff80467528 000003ff80440c14
> 00:  000003e0043bf2c8                                                           
> 00: [  424.579461] Krnl Code: 000003ff80440db6: a774ff5a            brc     7,00
> 00: 0003ff80440c6a                                                              
> 00: [  424.579461]            000003ff80440dba: a7f4ff54            brc     15,0
> 00: 00003ff80440c62                                                             
> 00: [  424.579461]           #000003ff80440dbe: af000000            mc      0,0 
> 00: [  424.579461]           >000003ff80440dc2: a798ffa1            lhi     %r9,
> 00: -95                                                                         
> 00: [  424.579461]            000003ff80440dc6: a51d0300            llihl   %r1,
> 00: 768                                                                         
> 00: [  424.579461]            000003ff80440dca: b90800b1            agr     %r11
> 00: ,%r1                                                                        
> 00: [  424.579461]            000003ff80440dce: d70bb000b000        xc      0(12
> 00: ,%r11),0(%r11)                                                              
> 00: [  424.579461]            000003ff80440dd4: b9140029            lgfr    %r2,
> 00: %r9                                                                         
> 00: [  424.586765] Call Trace:                                                  
> 00: [  424.586894]  [<000003ff80440dc2>] handle_pqap+0x2ba/0x468 [kvm]          
> 00: [  424.587026]  [<000003ff80446fa6>] kvm_s390_handle_b2+0x2f6/0x950 [kvm]   
> 00: [  424.587156]  [<000003ff8042d74c>] kvm_handle_sie_intercept+0x154/0x1db0 [
> 00: kvm]                                                                        
> 00: [  424.587287]  [<000003ff80426950>] __vcpu_run+0x1040/0x2150 [kvm]         
> 00: [  424.587414]  [<000003ff8042941a>] kvm_arch_vcpu_ioctl_run+0x5fa/0x1338 [k
> 00: vm]                                                                         
> 00: [  424.587540]  [<000003ff8040195e>] kvm_vcpu_ioctl+0x346/0xa10 [kvm]       
> 00: [  424.587590]  [<00000001433fbd16>] ksys_ioctl+0x276/0xbb8                 
> 00: [  424.587630]  [<00000001433fc682>] __s390x_sys_ioctl+0x2a/0x38            
> 00: [  424.587674]  [<000000014393c880>] system_call+0xd8/0x2b4                 
> 00: [  424.587715] 2 locks held by qemu-kvm/1533:                               
> 00: [  424.587748]  #0: 00000000822e80d0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcp
> 00: u_ioctl+0x170/0xa10 [kvm]                                                   
> 00: [  424.587898]  #1: 0000000081fe3980 (&kvm->srcu){....}-{0:0}, at: __vcpu_ru
> 00: n+0x60a/0x2150 [kvm]                                                        
> 00: [  424.588045] Last Breaking-Event-Address:                                 
> 00: [  424.588169]  [<000003ff80440c1e>] handle_pqap+0x116/0x468 [kvm]          
> 00: [  424.588204] irq event stamp: 23141                                       
> 00: [  424.588246] hardirqs last  enabled at (23149): [<000000014308f3de>] conso
> 00: le_unlock+0x766/0xa20                                                       
> 00: [  424.588287] hardirqs last disabled at (23156): [<000000014308ee40>] conso
> 00: le_unlock+0x1c8/0xa20                                                       
> 00: [  424.588536] softirqs last  enabled at (22998): [<000000014393e162>] __do_
> 00: softirq+0x6e2/0xa48                                                         
> 00: [  424.588583] softirqs last disabled at (22983): [<0000000142f652dc>] do_so
> 00: ftirq_own_stack+0xe4/0x100                                                  
> 00: [  424.588625] ---[ end trace e420441aa7c001ac ]---     
> 
