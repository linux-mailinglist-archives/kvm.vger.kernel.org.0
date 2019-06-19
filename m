Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C404C270
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 22:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfFSUeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 16:34:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfFSUeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 16:34:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JKTaIX035235;
        Wed, 19 Jun 2019 20:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=tGyWI6NN5WU6txVUe0woeURTjNvUZfYNbPS97ShuSzU=;
 b=jsHbSwbgDjRJNmIM/NIKoU2E+ewBUUMfMRVVhp81bpM96HfyGq5j657GOYbFzDe5eiyq
 p/hdS60RvW/INs8c/Aef+TA1fU8eh0QdREtejLqa2wE+mlq/J27Tx6f3jkyDiQPcUhj3
 zoGZ2bbheEpEScLRkJqOaQbaGBGJnhAv6qS7l4Dg5o6Evvy16ZiWd8ZUYbyQj3wZyfsH
 bkKBb9qVwhN/SmMa/2lBFZ0HBgbkxULXaRQnB4Uga/GpeRBTmYHXccaM7IzWQ1rVmCnx
 t610LOS2cmykuzu7DaDzI/lLaiVs0V3rMFp2XPFOwYdTjkAknwxRiQqwvz++g8BDYdEy yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t7809dh6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 20:33:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JKXXQx128597;
        Wed, 19 Jun 2019 20:33:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t77yp25hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 20:33:37 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JKXbmW024424;
        Wed, 19 Jun 2019 20:33:37 GMT
Received: from [192.168.14.112] (/109.64.216.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 13:33:37 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [Qemu-devel] [QEMU PATCH v4 01/10] target/i386: kvm: Delete VMX
 migration blocker on vCPU init failure
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <d7cf4dd5-13ca-9ba1-2424-25d0d2de8c58@oracle.com>
Date:   Wed, 19 Jun 2019 23:33:28 +0300
Cc:     qemu-devel@nongnu.org, ehabkost@redhat.com, kvm@vger.kernel.org,
        mtosatti@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, jmattson@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A469CD35-A0D9-4FB3-B9B5-3D3B97B32063@oracle.com>
References: <20190619162140.133674-1-liran.alon@oracle.com>
 <20190619162140.133674-2-liran.alon@oracle.com>
 <d7cf4dd5-13ca-9ba1-2424-25d0d2de8c58@oracle.com>
To:     Maran Wilson <maran.wilson@oracle.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Jun 2019, at 23:30, Maran Wilson <maran.wilson@oracle.com> =
wrote:
>=20
> On 6/19/2019 9:21 AM, Liran Alon wrote:
>> Commit d98f26073beb ("target/i386: kvm: add VMX migration blocker")
>> added migration blocker for vCPU exposed with Intel VMX because QEMU
>> doesn't yet contain code to support migration of nested =
virtualization
>> workloads.
>>=20
>> However, that commit missed adding deletion of the migration blocker =
in
>> case init of vCPU failed. Similar to invtsc_mig_blocker. This commit =
fix
>> that issue.
>>=20
>> Fixes: d98f26073beb ("target/i386: kvm: add VMX migration blocker")
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>>  target/i386/kvm.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> index 3b29ce5c0d08..7aa7914a498c 100644
>> --- a/target/i386/kvm.c
>> +++ b/target/i386/kvm.c
>> @@ -940,7 +940,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>        r =3D kvm_arch_set_tsc_khz(cs);
>>      if (r < 0) {
>> -        goto fail;
>> +        return r;
>>      }
>>        /* vcpu's TSC frequency is either specified by user, or =
following
>> @@ -1295,7 +1295,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>              if (local_err) {
>>                  error_report_err(local_err);
>>                  error_free(invtsc_mig_blocker);
>> -                return r;
>> +                goto fail2;
>>              }
>>          }
>>      }
>> @@ -1346,6 +1346,9 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>     fail:
>>      migrate_del_blocker(invtsc_mig_blocker);
>> + fail2:
>> +    migrate_del_blocker(vmx_mig_blocker);
>> +
>=20
> At the risk of being a bit pedantic...
>=20
> Your changes don't introduce this problem, but they do make it worse =
-- Since [vmx|invtsc]_mig_blocker are both global in scope, isn't it =
possible you end up deleting one or both valid blockers that were =
created by a previous invocation of kvm_arch_init_vcpu() ?  Seems to me =
that you would need something like an additional pair of local boolean =
variables named created_[vmx|invtsc]_mig_blocker and condition the calls =
to migrate_del_blocker() accordingly. On the positive side, that would =
simplify some of the logic around when and if it's ok to jump to "fail" =
(and you wouldn't need the "fail2").
>=20
> Thanks,
> -Maran

I actually thought about this as-well when I encountered this issue.
In general one can argue that every vCPU should introduce it=E2=80=99s =
own migration blocker on init (if required) and remove it=E2=80=99s own =
migration blocker on deletion (on vCPU destroy).
On 99% of the time, all of this shouldn=E2=80=99t matter as all vCPUs of =
a given VM have exactly the same properties.
Anyway, I decided that this is entirely not relevant for this =
patch-series and therefore if this should be addressed further, let it =
be another unrelated patch-series.
QEMU have too many issues to fix all at once :P. I need to filter.

-Liran

>=20
>>      return r;
>>  }
>> =20

