Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E82E731A45
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 15:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344504AbjFONlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 09:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344565AbjFONkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 09:40:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D913AAE;
        Thu, 15 Jun 2023 06:39:50 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FDbGqq007781;
        Thu, 15 Jun 2023 13:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=3MPW3l4/WFjhrlzMKhNx7kymAhv4MUN6so9NzDBHQxc=;
 b=F5wliBVO7qh2T0vGBN3Nnm5lwe1KaKzQsdhUfzXuOz8DzKhn/YVSZnr2R2QuFdrZqTeO
 titsSPPmhpkaetZW7q/3zpGe7wNtd0mkpZdJn6UaowlP8R53A7vcj55yWDvdKYiW0eNh
 1k0NJQ8tk6O1hjgenXuSdVYlCU5FlxZC6Bm3cLhc8+nyjFqtAGkvGV30ul8vQMMvU8N0
 MIScRBlkn4br4W6NwjVqaEt3Pu0wHblsalCVVcvMohK/gcO/IFonkQf4R6fPLtt0gsIn
 v7j/iRcknzRa8L1JhJkHws3k/kL3vLcHuVpdTcW6OcRhUh0YZ0pF8IeoDSNLu6A9BiGi Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r83ex8hmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 13:39:43 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35FDbd8i010027;
        Thu, 15 Jun 2023 13:39:42 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r83ex8h9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 13:39:42 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35F2xChr008934;
        Thu, 15 Jun 2023 13:39:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3r4gt53m6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jun 2023 13:39:33 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35FDdU2J58851734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 13:39:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1446720040;
        Thu, 15 Jun 2023 13:39:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E5E520043;
        Thu, 15 Jun 2023 13:39:29 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.73.29])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jun 2023 13:39:29 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230615062148.19883-1-gshan@redhat.com>
References: <20230615062148.19883-1-gshan@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, andrew.jones@linux.dev,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        shan.gavin@gmail.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v3] runtime: Allow to specify properties for accelerator
Message-ID: <168683636810.207611.6242722390379085462@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 15 Jun 2023 15:39:28 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1cVP92Ij_fJpEbFMdprEJWeCVFh8b4yH
X-Proofpoint-ORIG-GUID: VlfDZs5XE3eIcEHztMzmw4tIK1PTH_g6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-15_09,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Gavin Shan (2023-06-15 08:21:48)
> There are extra properties for accelerators to enable the specific
> features. For example, the dirty ring for KVM accelerator can be
> enabled by "-accel kvm,dirty-ring-size=3D65536". Unfortuntely, the
> extra properties for the accelerators aren't supported. It makes
> it's impossible to test the combination of KVM and dirty ring
> as the following error message indicates.
>=20
>   # cd /home/gavin/sandbox/kvm-unit-tests/tests
>   # QEMU=3D/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
>     ACCEL=3Dkvm,dirty-ring-size=3D65536 ./its-migration
>      :
>   BUILD_HEAD=3D2fffb37e
>   timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu=
-system-aarch64 \
>   -nodefaults -machine virt -accel kvm,dirty-ring-size=3D65536 -cpu corte=
x-a57             \
>   -device virtio-serial-device -device virtconsole,chardev=3Dctd -chardev=
 testdev,id=3Dctd   \
>   -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere=
_ -smp 160      \
>   -machine gic-version=3D3 -append its-pending-migration # -initrd /tmp/t=
mp.gfDLa1EtWk
>   qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Inva=
lid argument
>=20
> Allow to specify extra properties for accelerators. With this, the
> "its-migration" can be tested for the combination of KVM and dirty
> ring.
>=20
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Maybe get_qemu_accelerator could be renamed now, since it doesn't actually =
"get"
anything, so maybe check_qemu_accelerator?

In any case, I gave it a quick run on s390x with kvm and tcg and nothing se=
ems
to break, hence for the changes in s390x:

Tested-by: Nico Boehr <nrb@linux.ibm.com>
Acked-by: Nico Boehr <nrb@linux.ibm.com>
