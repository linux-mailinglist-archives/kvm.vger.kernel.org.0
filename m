Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0995A1B4F5
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 13:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbfEMLcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 07:32:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfEMLcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 07:32:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DBTmO9022438;
        Mon, 13 May 2019 11:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : in-reply-to :
 references : mime-version : content-type : content-transfer-encoding :
 subject : to : cc : from : message-id; s=corp-2018-07-02;
 bh=mty2FTNVjpIhbBYL90IRRZYhieT+z0m3OF2KXzFfb4s=;
 b=tMtheo4V5BPIrgk/ODsU8scP6HoOVFPZHjJPfpeg3YU9qzBq5VpsEAXEbSJmKFTU47ae
 RCAe2v8N0gWK87Tj8gFnstZmnzz+cRMGBhIiKlv4XnqFL6g4e4WhKUXUJ2fgX1au1HAQ
 Op7rFVGoaomAlPI8hOBpdZzcE0itGY1Vxiir44+WFlh9w68FQJ3L0k4/silHhunER6il
 VhEUbBtFhI1I+wi6u5IE3t2fOFgGhK9l0lmIqj+zWtpqNSiuVuGwzjy9vHr4TvMhWtmE
 P/nXn+0p82+OoJc/1MVcsKDMHFEh4Jn44Gau6t55QQBVSl7D9ZJzDcS27B3UyFxw5i+t 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sdq1q65fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 11:31:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DBVHUV176927;
        Mon, 13 May 2019 11:31:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2se0tvga2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 11:31:43 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4DBVfXB010387;
        Mon, 13 May 2019 11:31:41 GMT
Received: from galaxy-s9.lan (/209.6.36.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 04:31:40 -0700
Date:   Mon, 13 May 2019 07:31:37 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
References: <20190507185647.GA29409@amt.cnet> <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     Wanpeng Li <kernellwp@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, ankur.a.arora@oracle.com,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <D655C66D-8C52-4CE3-A00B-697735CFA51D@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130083
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On May 13, 2019 5:20:37 AM EDT, Wanpeng Li <kernellwp@gmail=2Ecom> wrote:
>On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat=2Ecom>
>wrote:
>>
>>
>> Certain workloads perform poorly on KVM compared to baremetal
>> due to baremetal's ability to perform mwait on NEED_RESCHED
>> bit of task flags (therefore skipping the IPI)=2E
>
>KVM supports expose mwait to the guest, if it can solve this?
>


There is a bit of problem with that=2E The host will see 100% CPU utilizat=
ion even if the guest is idle and taking long naps=2E=2E

Which depending on your dashboard can look like the machine is on fire=2E

CCing Ankur and Boris

>Regards,
>Wanpeng Li
>
>>
>> This patch introduces a configurable busy-wait delay before entering
>the
>> architecture delay routine, allowing wakeup IPIs to be skipped
>> (if the IPI happens in that window)=2E
>>
>> The real-life workload which this patch improves performance
>> is SAP HANA (by 5-10%) (for which case setting idle_spin to 30
>> is sufficient)=2E
>>
>> This patch improves the attached server=2Epy and client=2Epy example
>> as follows:
>>
>> Host:                           31=2E814230202231556
>> Guest:                          38=2E17718765199993       (83 %)
>> Guest, idle_spin=3D50us:          33=2E317709898000004      (95 %)
>> Guest, idle_spin=3D220us:         32=2E27826551499999       (98 %)
>>
>> Signed-off-by: Marcelo Tosatti <mtosatti@redhat=2Ecom>
>>
>> ---
>>  kernel/sched/idle=2Ec |   86
>++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 86 insertions(+)
>>
>> diff --git a/kernel/sched/idle=2Ec b/kernel/sched/idle=2Ec
>> index f5516bae0c1b=2E=2Ebca7656a7ea0 100644
>> --- a/kernel/sched/idle=2Ec
>> +++ b/kernel/sched/idle=2Ec
>> @@ -216,6 +216,29 @@ static void cpuidle_idle_call(void)
>>         rcu_idle_exit();
>>  }
>>
>> +static unsigned int spin_before_idle_us;
>>
>> +static void do_spin_before_idle(void)
>> +{
>> +       ktime_t now, end_spin;
>> +
>> +       now =3D ktime_get();
>> +       end_spin =3D ktime_add_ns(now, spin_before_idle_us*1000);
>> +
>> +       rcu_idle_enter();
>> +       local_irq_enable();
>> +       stop_critical_timings();
>> +
>> +       do {
>> +               cpu_relax();
>> +               now =3D ktime_get();
>> +       } while (!tif_need_resched() && ktime_before(now, end_spin));
>> +
>> +       start_critical_timings();
>> +       rcu_idle_exit();
>> +       local_irq_disable();
>> +}
>> +
>>  /*
>>   * Generic idle loop implementation
>>   *
>> @@ -259,6 +282,8 @@ static void do_idle(void)
>>                         tick_nohz_idle_restart_tick();
>>                         cpu_idle_poll();
>>                 } else {
>> +                       if (spin_before_idle_us)
>> +                               do_spin_before_idle();
>>                         cpuidle_idle_call();
>>                 }
>>                 arch_cpu_idle_exit();
>> @@ -465,3 +490,64 @@ const struct sched_class idle_sched_class =3D {
>>         =2Eswitched_to            =3D switched_to_idle,
>>         =2Eupdate_curr            =3D update_curr_idle,
>>  };
>> +
>> +
>> +static ssize_t store_idle_spin(struct kobject *kobj,
>> +                              struct kobj_attribute *attr,
>> +                              const char *buf, size_t count)
>> +{
>> +       unsigned int val;
>> +
>> +       if (kstrtouint(buf, 10, &val) < 0)
>> +               return -EINVAL;
>> +
>> +       if (val > USEC_PER_SEC)
>> +               return -EINVAL;
>> +
>> +       spin_before_idle_us =3D val;
>> +       return count;
>> +}
>> +
>> +static ssize_t show_idle_spin(struct kobject *kobj,
>> +                             struct kobj_attribute *attr,
>> +                             char *buf)
>> +{
>> +       ssize_t ret;
>> +
>> +       ret =3D sprintf(buf, "%d\n", spin_before_idle_us);
>> +
>> +       return ret;
>> +}
>> +
>> +static struct kobj_attribute idle_spin_attr =3D
>> +       __ATTR(idle_spin, 0644, show_idle_spin, store_idle_spin);
>> +
>> +static struct attribute *sched_attrs[] =3D {
>> +       &idle_spin_attr=2Eattr,
>> +       NULL,
>> +};
>> +
>> +static const struct attribute_group sched_attr_group =3D {
>> +       =2Eattrs =3D sched_attrs,
>> +};
>> +
>> +static struct kobject *sched_kobj;
>> +
>> +static int __init sched_sysfs_init(void)
>> +{
>> +       int error;
>> +
>> +       sched_kobj =3D kobject_create_and_add("sched", kernel_kobj);
>> +       if (!sched_kobj)
>> +               return -ENOMEM;
>> +
>> +       error =3D sysfs_create_group(sched_kobj, &sched_attr_group);
>> +       if (error)
>> +               goto err;
>> +       return 0;
>> +
>> +err:
>> +       kobject_put(sched_kobj);
>> +       return error;
>> +}
>> +postcore_initcall(sched_sysfs_init);

