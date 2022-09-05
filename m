Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005105AD19D
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 13:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiIELdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 07:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiIELdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 07:33:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADE458DF9
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 04:33:01 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 285AoYkG025359;
        Mon, 5 Sep 2022 11:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=wH6rY6SVNBsAjTsTqFIqXcV5NcBss/lC8JtRtplw33c=;
 b=WE7x4D6bcLQf5RlkQUCdxsDfrqRzXriyuIiozhyYQaTdbYt4Q1z+I7ce/6NuvYq2Bbow
 5nTObO/7GwreSlXop07XuFv+QQVYEAS8I1MKtrrKn/rOeNhjKESkMnrUyu8rQq/4lpEC
 vK+9wwt3EfVRw3J869b/+QRAIwAl3IAgekcSBDDUwP+VLwDP84RnXkM57eV68SZY5y5n
 5YQU7O5ITbiiqGl7DSr5HaqxNypSnzfLqbaMOGcHUU2LE7LZZZUcegm2pS11AhKKNzix
 UALSSA7A5qhrHyWI9NR/gd5kdtnOGzfGI2Kt64suSYdXwPrDNsGtXvJXOFl1sGiAzAJ4 ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdfqe1ade-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 11:32:54 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 285BRNL3010397;
        Mon, 5 Sep 2022 11:32:54 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdfqe1aay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 11:32:54 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 285BLU0B012766;
        Mon, 5 Sep 2022 11:32:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3jbxj8hqxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 11:32:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 285BWmbP40698348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 11:32:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70A8BA404D;
        Mon,  5 Sep 2022 11:32:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 523A6A4040;
        Mon,  5 Sep 2022 11:32:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.183])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Sep 2022 11:32:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220902075531.188916-2-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com> <20220902075531.188916-2-pmorel@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Message-ID: <166237756810.5995.16085197397341513582@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 05 Sep 2022 13:32:48 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aRCgWzmIRdDvmmVq4r4FgyxwR0FR5LBc
X-Proofpoint-GUID: Mqbc26mP2_e8XaUu0c9wP5GdH64ChxFl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_08,2022-09-05_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1011 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2022-09-02 09:55:22)
> S390x do not support multithreading in the guest.
> Do not let admin falsely specify multithreading on QEMU
> smp commandline.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/s390-virtio-ccw.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 70229b102b..b5ca154e2f 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -86,6 +86,9 @@ static void s390_init_cpus(MachineState *machine)
>      MachineClass *mc =3D MACHINE_GET_CLASS(machine);
>      int i;
> =20
> +    /* Explicitely do not support threads */
          ^
          Explicitly

> +    assert(machine->smp.threads =3D=3D 1);

It might be nicer to give a better error message to the user.
What do you think about something like (broken whitespace ahead):

    if (machine->smp.threads !=3D 1) {
        error_setg(&error_fatal, "More than one thread specified, but multi=
threading unsupported");
        return;
    }
