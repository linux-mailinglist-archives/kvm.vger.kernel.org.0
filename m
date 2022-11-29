Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93563C8D3
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbiK2T4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbiK2T4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:56:47 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F706140B0;
        Tue, 29 Nov 2022 11:56:45 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATGIbc8013895;
        Tue, 29 Nov 2022 11:56:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=wSgLBctoKAhDLVVi2JG1SLWaRgQgF432OkSE9fhDnUo=;
 b=Ts2Wls7XUe7pJePk/bfxbqWUuRlXDeQh/AALHAtCR1OnUVCI01cpZdvlGxETCLtHwvry
 5s3xBkyV8BDyO6tvBBYEmOR4CJFqrZXEXs6FY54ijxOFhM/av4Yay1ronCX2sJka4V6T
 b/MUfLPQZ3nusPe3K6o5DjAPQ5SPSVLPb5YiiHtxqxXvBsdLU9rDMpCUMZuoNtLBLXtn
 dvR2eFQbodN5H0+k8eiZT6pMmAppoQQ1Mhc1c5shfza4/dOiBtZzTb7qT99uZ/UEnlo1
 kwAhz4deYBLpHtWPTquKgc1YsMq0Cua2TucBFxS8xZz7oNn/FKi2KEJFut0lPGBzKmUb Dw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3m3fkfyw67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 11:56:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTewxUd2+dSegObMUG2NH7jRmJOi2DFRDOfRfHqB/K9q6jAuUBc7GTLBbqjQhEz/m3k2j7NhoIiz4ETV2yKW6QqeGunuxQUHtU9bloH8+vjBBFs/k35xUPlBOoRxn7jmzNwZeipc+tSboRPQPonAAog9OtSxHRc481xwLuEkKrdhXBknsvbPwTrK7sMl84KxlRm7itn7/heF3m8AiGvt2ECk/xh4JaP+ThnCjsEqBLaYRkCpiqWb7y34THBhaUcTAdV+KZDtCKBbeP9jFT9WLRRCihvufrquNLm35yDv65dkXhhGbEmrNFee4/LQpeZsQYNx1F5+wpeX+0t4a/Cqbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wSgLBctoKAhDLVVi2JG1SLWaRgQgF432OkSE9fhDnUo=;
 b=WUGPQKK98Ke2AeP6UkBQ5NPpzwpht1EMRjqcapaaMITYHayHcm7mjZRc0Ard4O4Q2z5XbfJCT1Jgr0whf9gyi5fmO5TscXRt8NwIEVAr+dK6s7rsU+8puouIhl1RPQcS6JNHCv2Uv2VFlLEUzssJWMm/3AzsEv5Lc9roidBdvsPehWdKnN05SxeO/gFbg9etoRKHxL2QIk58yc8h03rVBmWm/IsvhHBU6QFxoQaFfdZjGyB8g7g4PaVTdNqC2aUVF37ctVH3U7hRCW23J0i/imqaSrJaZRz7WAVGLrZV6WAANLJ5XsPqjf17w5qRC26PN1BrlxWh35KF2hmrBHkuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSgLBctoKAhDLVVi2JG1SLWaRgQgF432OkSE9fhDnUo=;
 b=XJi37X/DhW/HBS2hUy8rv6+cUKBowyd2rjDM6H66WcYzNYx/sItD1uMP9X3hWdsnYESG5KnaxM3zW2Jcb+/IVjJFrzOAHh12YFCL9lWKraeyFSucXyNTHTRH0iaOYKFk3CvWqO8LbCgiXobU8sks3Q1CsFC/zcLjlPcZVHchVXJSGhZ/7QNrUF0YgTFpN8Ebjq1y069PRP2OktAd+/rYvOqUxL6nBqFnqQCq1TbsllSu8miTlxbc+tA41MIc8CvSbkhx6CdaRl4n4qb9+19scseuaZQt9LGiUHs2unHc326M+MXkpsNI3+MFmSOBE3TbonJeADcuTmU2NTp/BaYBnw==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA2PR02MB7610.namprd02.prod.outlook.com (2603:10b6:806:14a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 19:56:12 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 19:56:12 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Topic: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Index: AQHZBB+UbwHM6Ykv6ESmts8I/MP46K5WToGAgAACgYA=
Date:   Tue, 29 Nov 2022 19:56:12 +0000
Message-ID: <E3693FA8-7818-495B-9F40-42AEEE756142@nutanix.com>
References: <20221129182226.82087-1-jon@nutanix.com>
 <5162c4cbaaae8de01c77093ac005c2f5abc1d040.camel@redhat.com>
In-Reply-To: <5162c4cbaaae8de01c77093ac005c2f5abc1d040.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|SA2PR02MB7610:EE_
x-ms-office365-filtering-correlation-id: 1dd9d0b3-9799-4023-9dc4-08dad243c434
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1hf/YMOtUESizd7B2gpwqQlyd5RX1jZy1z7XeBDbSXxVriF1VhP8R4wc+NIUZLFAZE5rm7IAb0FpTxaIN+2ad2gejP8GxvKTqRlpdqdxnD6XSQ20nUtCx8Oos3mnSAp4So4P89mG28AEXNeav3jA/67PzC7WLMToGIGt5dRuvvOtTqzec9gSXU6OsIXUpLCIfwCq3DnETnbvlfsbQ58RqbNFyjxrlb8RxTyLmFYJJD6Y/uzKflTR18u406WCkQBjQnaChljisM0NQpFjVsCvIxkUxm9tzTkB6fjMO+nOskpOCwnJT9+rZBWj/bVh736wIm4p1lpfYWmtOttCyE2vLTp7yvQGuBasb0+GtQiFglU4vi9AB+/0N6YCZpV2cO5xEq7rzVsDg46rznOnJZ6d6lvlZJ1y/FEedVj0x/KOKweRVUDGiRuJcZ14+5XeuRowY5gVPFCff40gNAHAg9CwTlsgTXknj8TzAP2WTvvmcs/VZZOrwwbCiDvszw6pm7nLCFzJqtlww70djvQ2hUEllfd4jfXZ/QvdgNTZ+c1jI1S/9W9TTxAZ2Pr+IVNwuBIis6CRjV/L0B0lHpIL5LpgS3fqchie42jHGGJQugVeF7FMU1PMytaPgqOD0uJfFX2ljxKI41LwmDqsmM+/CZs8xz4a+m4p+KG62VkLfY38GZC2s4pmE9dIm0AKxxC7Ymj8LTVpOjnOgotiZU7n2a+f1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199015)(7416002)(122000001)(64756008)(8676002)(66446008)(5660300002)(4326008)(6506007)(66476007)(71200400001)(86362001)(2616005)(53546011)(41300700001)(54906003)(6916009)(8936002)(186003)(38100700002)(6512007)(36756003)(316002)(66899015)(33656002)(2906002)(4001150100001)(38070700005)(6486002)(83380400001)(91956017)(478600001)(76116006)(66946007)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7GePqog7URwWTwNHu9e7Eo+mDZ4uSc/PyhE+ObCQ93oZrEp/rbEnJEm10+ls?=
 =?us-ascii?Q?NWWP6f3bBMEbH2sl+1hgXTxTtDUqosf4HR03Ej37MDPFWJvS3REJpp3MCrUU?=
 =?us-ascii?Q?yUsZiaKa5df0qBHX8+06d40zz0MaykUE4LquWxTAGiks1e+RCK2EVKXUzBUV?=
 =?us-ascii?Q?d0/xVuqFZQUErbrufLjDH73pcUeu1CjN1wpP6myfilXds/ZZ5jHl/h0cCbo9?=
 =?us-ascii?Q?yYxHLyJpmBMzGmiA3LbMCSL3ItW+CaAxDe2u3TAJ12spvQ1ycw9fOoKQd82L?=
 =?us-ascii?Q?EVziJv8wotb6JnswwBT/d2dVWDt2Oo6XVtcpzbuROcB4do7SbmQus7O7IDrj?=
 =?us-ascii?Q?Lon0r3/Ikpp+CW+lOb0P+9V3KzUDeE2FB4tKRah8/0dfELDMIWcNlvt+Adgw?=
 =?us-ascii?Q?eyTKQoywmV1CyHkE/0MplXqosdq4S71cceUicza3vL6hU/6PbL7bCAbtXq8/?=
 =?us-ascii?Q?IyBa+KipJLqXxCAZbyddDG9UfT+NUF4lzuCQP8rOzhJRmU9DJ2FJCCpvhD67?=
 =?us-ascii?Q?k4mJyiwJwdgwyn1qHq/Dv1/h9NZr/vChxHYW7pzZVsV+YWjUHxgVCl/DehF8?=
 =?us-ascii?Q?01eEcxlagiKVqcol3h/nkws+xL3yK0amctvbaQiTgZUM89XSYeJbW8FHeoPF?=
 =?us-ascii?Q?JcbA1MfEyfk55nMCJFCvYn8M/CfSfUl+MfDpa1zTuEb/XIDgk5MBPTiyGb+e?=
 =?us-ascii?Q?Xdl1hqTPHTHWyjN75VucTG+GCv7yxK+t3e5onaPQ76W5wilTA+7KluKMrFuA?=
 =?us-ascii?Q?q6IC5XLWltLCGak8ASd/6NFJU6VrfNAvs7ZZjxswY7aDgvF6rbmUQAOJIwst?=
 =?us-ascii?Q?dIaISRiBnsdzeqd9AlZWfMRK16rJi+ChQNfC0ZVMyF+8SQxKGJYFakUPSGPQ?=
 =?us-ascii?Q?UfHe0KWgav/8TmqJzqnI9dfUO2QKNwJGf7S7FPQfdVfT0YrJ6d6XduJPlm9s?=
 =?us-ascii?Q?AAoI+CRyGmXJ5lhRAV2lDWnSy7hJe6+o82Q9ea8jBtqyBH6GVbJ8FqtBrUyt?=
 =?us-ascii?Q?WBF8b9XW9LHYgPlZqentz9yiGDeaEdeEm9ZVtX6D/17bHFrJoTgT0RzdJFnb?=
 =?us-ascii?Q?vAbXwhmooXWUa+7AjnzccWSc1XywZIOwvsFqGv57Mny4yAYqjmGcUEnpyki8?=
 =?us-ascii?Q?I0rVN9xcYOXqe9qtyt4sY0xO23Nta12TkBOHIvXp7sN2/qiIalMg4SJtGTpZ?=
 =?us-ascii?Q?C/u9n6qrpwEmpnbsrid0t/z/vLLJZQpmUjEC6hD1sUzoFd9xqtb8K491PxZ8?=
 =?us-ascii?Q?bYE41Do6yDFxmWTQ8M07Tasg+aiAdTNmUUoZql1ntI94RYEaq7uFSXDRbHkG?=
 =?us-ascii?Q?ghS4GBzn2bfAh//HKlhgBfmhmWbibgMpwBk3isCyJFeSAnWppTpT+OyJjwDj?=
 =?us-ascii?Q?Aw4DsvhMI3O5roOMxhUgctQUYA4rDSxoW4BODdgpZ9k8UCHdj21vP/cuMx3V?=
 =?us-ascii?Q?e7vR/qyFEgpE66WP1VQs4NMWcM56Votkj+tJ2yW6hc4gRCVk2UtyJKEyeAdf?=
 =?us-ascii?Q?7v7Ep13VSfjK0jTrCVucL6LFTiTVILGk3GCoxYxIedrs0QC60WyzRTkWnvMY?=
 =?us-ascii?Q?fSZNv3/x+toxYIc7ZeyaIwYXk9EX6PkopfCdN45btXxbyZK7fRI+braKbxFJ?=
 =?us-ascii?Q?E0LKZw4Ikzo/RJtM/jbm9IezEGhX2y1VUS3nJnU6AFzunU80BO3znorWoTL9?=
 =?us-ascii?Q?8Gx+mQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3EB713BFA99B5B45981829130A77A0D9@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd9d0b3-9799-4023-9dc4-08dad243c434
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 19:56:12.2458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zsUpse0WTDbgdrJoGnZ94EwfVXbAQHtXD7mEhpR+Nih8R5KY4h13CRqZfEgX0rUC2gGWXABcOwjee8Y803vRZGoKerPTlVRCaEBhOxsVTIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7610
X-Proofpoint-GUID: kNbxlxyrPKeDEmHsJCv7_b9IL9PLP81H
X-Proofpoint-ORIG-GUID: kNbxlxyrPKeDEmHsJCv7_b9IL9PLP81H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_11,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Nov 29, 2022, at 2:47 PM, Maxim Levitsky <mlevitsk@redhat.com> wrote:
>=20
> On Tue, 2022-11-29 at 13:22 -0500, Jon Kohler wrote:
>> Set vcpu->mode to EXITING_GUEST_MODE as soon vCPU exits to reflect
>> that we are indeed exiting guest mode, but not quite out of guest
>> mode yet. Note: This is done lazily without an explicit memory
>> barrier so that we do not regress the cost in the critical path
>> of going from the exit to the exit handler.
>>=20
>> Flip back to IN_GUEST_MODE for exits that use
>> EXIT_FASTPATH_REENTER_GUEST, such that we are IN_GUEST_MODE upon
>> reentry.
>>=20
>> Changing vcpu->mode away from IN_GUEST_MODE as early as possible
>> gives IPI senders as much runway as possible to avoid ringing
>> doorbell or sending posted interrupt IPI in AMD and Intel,
>> respectively. Since this is done without an explicit memory
>> barrier, the worst case is that the IPI sender sees IN_GUEST_MODE
>> still and sends a spurious event, which is the behavior prior
>> to this patch.
>=20
> Beware that we had a king sized bug in regard to AVIC inhibition races
> vs guest entries, this this should be carefully checked for this.

Thanks, Maxim - any pointers on what we should be looking for here?

>=20
> Also, do you have any perf numbers to see if that actually improves perfo=
rmance?
> (I am just curious, I do think that this can improve performance).
>=20

Yes indeed! Sorry I should have put that right in the commit msg as a note,
but using the kvm-unit-tests vmexit_ipi with -smp 20 on an Intel 8168 its
roughly ~3% better (~3325-ish vs ~3400-ish), though the test is a bit noisy
even with taskset to a single socket.

To help validate that we were even getting *any* benefit, in a local build
I added a log statement (rough code below) to IPI delivery path, and did se=
e=20
many, many IPIs getting suppressed that would have otherwise fired.

kvm_vcpu_trigger_posted_interrupt() {
...
    if (vcpu->mode =3D=3D EXITING_GUEST_MODE) {
        pr_warn_ratelimited("exiting suppression worked");
    }
...
}

> Best regards,
> 	Maxim Levitsky
>=20
>=20
>>=20
>> Signed-off-by: Jon Kohler <jon@nutanix.com>
>> ---
>> arch/x86/kvm/svm/svm.c |  7 +++++++
>> arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
>> arch/x86/kvm/x86.c     |  8 ++++++++
>> 3 files changed, 38 insertions(+)
>>=20
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index ce362e88a567..5f0c118a3ffd 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3907,6 +3907,13 @@ static noinstr void svm_vcpu_enter_exit(struct kv=
m_vcpu *vcpu, bool spec_ctrl_in
>> 	else
>> 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
>>=20
>> +	/* Optimize IPI reduction by setting mode immediately after vmexit
>> +	 * without a memmory barrier as this as not paired anywhere. vcpu->mod=
e
>> +	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memo=
ry
>> +	 * barrier, after the host is done fully restoring various host states=
.
>> +	 */
>> +	vcpu->mode =3D EXITING_GUEST_MODE;
>> +
>> 	guest_state_exit_irqoff();
>> }
>>=20
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 63247c57c72c..243dcb87c727 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5878,6 +5878,17 @@ static fastpath_t handle_fastpath_preemption_time=
r(struct kvm_vcpu *vcpu)
>>=20
>> 	if (!vmx->req_immediate_exit &&
>> 	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
>> +		/* Reset IN_GUEST_MODE since we're going to reenter
>> +		 * guest as part of this fast path. This is done as
>> +		 * an optimization without a memory barrier since
>> +		 * EXITING_GUEST_MODE is also set without a memory
>> +		 * barrier. This also needs to be reset prior to
>> +		 * calling apic_timer_expired() so that
>> +		 * kvm_use_posted_timer_interrupt() returns the proper
>> +		 * value.
>> +		 */
>> +		if (vcpu->mode =3D=3D EXITING_GUEST_MODE)
>> +			vcpu->mode =3D IN_GUEST_MODE;
>> 		kvm_lapic_expired_hv_timer(vcpu);
>> 		return EXIT_FASTPATH_REENTER_GUEST;
>> 	}
>> @@ -7031,6 +7042,18 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx =
*vmx, unsigned long host_rsp)
>> void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
>> 					unsigned int flags)
>> {
>> +	struct kvm_vcpu *vcpu =3D &vmx->vcpu;
>> +
>> +	/* Optimize IPI reduction by setting mode immediately after vmexit
>> +	 * without a memmory barrier as this as not paired anywhere. vcpu->mod=
e
>> +	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memo=
ry
>> +	 * barrier, after the host is done fully restoring various host states=
.
>> +	 * Since the rdmsr and wrmsr below are expensive, this must be done
>> +	 * first, so that the IPI suppression window covers the time dealing
>> +	 * with fixing up SPEC_CTRL.
>> +	 */
>> +	vcpu->mode =3D EXITING_GUEST_MODE;
>> +
>> 	u64 hostval =3D this_cpu_read(x86_spec_ctrl_current);
>>=20
>> 	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 2835bd796639..0e0d228f3fa5 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2160,6 +2160,14 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct =
kvm_vcpu *vcpu)
>> 		data =3D kvm_read_edx_eax(vcpu);
>> 		if (!handle_fastpath_set_tscdeadline(vcpu, data)) {
>> 			kvm_skip_emulated_instruction(vcpu);
>> +			/* Reset IN_GUEST_MODE since we're going to reenter
>> +			 * guest as part of this fast path. This is done as
>> +			 * an optimization without a memory barrier since
>> +			 * EXITING_GUEST_MODE is also set without a memory
>> +			 * barrier.
>> +			 */
>> +			if (vcpu->mode =3D=3D EXITING_GUEST_MODE)
>> +				vcpu->mode =3D IN_GUEST_MODE;
>> 			ret =3D EXIT_FASTPATH_REENTER_GUEST;
>> 		}
>> 		break;

