Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AB36C7CEE
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 11:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjCXK7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 06:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXK7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 06:59:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3F0244A6;
        Fri, 24 Mar 2023 03:59:18 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32O8BlXD026575;
        Fri, 24 Mar 2023 10:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=JutvLkYdoewwqKSAlRU9KyRg6geqYFl/DCub9i41Zyc=;
 b=faYt6bHgFfSSm+97wMwFNl2yVMkNjJt11keSXHRLxYf3AUq9FsOAfgwmyTVGBERfOeVD
 fNsxJvpCqdypwJcKjH6eAt+q7Rj3AHeuUaatWG1grh3sxfL0aWI9jY8yT7RM2/sP9D9h
 Bo67ketcKL490dT1TXFM5TCTBiYp7/GzDRdVf45TgYpS3akQMGuWeyw8bzFU9eZQYjPl
 eALLGgHSwpM18kEj75Y8VXvHUbkjcgH+SW+dWMlIW0eCMpznoRHAVg5IfKupa98dFZPl
 qIDq7Z6FgAbXqzMdbllaMd55NvJENBHn8uh74lEDuWUU3H3dOTWUssbVws+nCWB0x15v ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph84ubqwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:59:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32O9mlO7036844;
        Fri, 24 Mar 2023 10:59:18 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph84ubqw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:59:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLuONB013783;
        Fri, 24 Mar 2023 10:59:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pgy3s0q74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:59:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OAxCkc18088452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 10:59:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC47E20040;
        Fri, 24 Mar 2023 10:59:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C235020043;
        Fri, 24 Mar 2023 10:59:11 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.14.197])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 10:59:11 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230320085642.12251-3-pmorel@linux.ibm.com>
References: <20230320085642.12251-1-pmorel@linux.ibm.com> <20230320085642.12251-3-pmorel@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 2/2] s390x: topology: Checking Configuration Topology Information
Message-ID: <167965555147.41638.10047922188597254104@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 24 Mar 2023 11:59:11 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6uVIjBQRksTzulAYt_BApdl5JFl971fh
X-Proofpoint-ORIG-GUID: D2WvtQE2J-d4SeqDqCwfsriLs7Snq6VQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 adultscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240082
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-03-20 09:56:42)
> STSI with function code 15 is used to store the CPU configuration
> topology.
>=20
> We retrieve the maximum nested level with SCLP and use the
> topology tree provided by the drawers, books, sockets, cores
> arguments.
>=20
> We check :
> - if the topology stored is coherent between the QEMU -smp
>   parameters and kernel parameters.
> - the number of CPUs
> - the maximum number of CPUs
> - the number of containers of each levels for every STSI(15.1.x)
>   instruction allowed by the machine.
[...]
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 390fde7..9679332 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -238,3 +238,8 @@ uint64_t get_max_ram_size(void)
>  {
>         return max_ram_size;
>  }
> +
> +uint64_t sclp_get_stsi_mnest(void)
> +{

maybe add:
assert(read_info);

[...]
> diff --git a/s390x/topology.c b/s390x/topology.c
> index ce248f1..11ce931 100644
> --- a/s390x/topology.c
> +++ b/s390x/topology.c
[...]
> +/*
> + * Topology level as defined by architecture, all levels exists with
> + * a single container unless overwritten by the QEMU -smp parameter.
> + */
> +static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL]; // =3D {1, 1, 1, 1, 1,=
 1};

So that's what is being provided to the test on the command line, right?

How about renaming this to expected_topo_lvl?

What do you mean by 'defined by architecture'?

[...]
> +/*
> + * stsi_check_mag
> + * @info: Pointer to the stsi information
> + *
> + * MAG field should match the architecture defined containers
> + * when MNEST as returned by SCLP matches MNEST of the SYSIB.
> + */
> +static void stsi_check_mag(struct sysinfo_15_1_x *info)
> +{
> +       int i;
> +
> +       report_prefix_push("MAG");
> +
> +       stsi_check_maxcpus(info);
> +
> +       /* Explicitly skip the test if both mnest do not match */
> +       if (max_nested_lvl !=3D info->mnest)
> +               goto done;

What does it mean if the two don't match, i.e. is this an error? Or a skip?=
 Or is it just expected?

[...]
> +/**
> + * check_tle:
> + * @tc: pointer to first TLE
> + *
> + * Recursively check the containers TLEs until we
> + * find a CPU TLE.
> + */
> +static uint8_t *check_tle(void *tc)
> +{
[...]
> +       report(!cpus->d || (cpus->pp =3D=3D 3 || cpus->pp =3D=3D 0),
> +              "Dedication versus entitlement");

Maybe skip here if the CPU is not dedicated? With shared CPUs we really can=
't check much here.

[...]
> +/*
> + * The Maximum Nested level is given by SCLP READ_SCP_INFO if the MNEST =
facility
> + * is available.
> + * If the MNEST facility is not available, sclp_get_stsi_mnest  returns =
0 and the
> + * Maximum Nested level is 2
> + */
> +#define S390_DEFAULT_MNEST     2
> +static int sclp_get_mnest(void)
> +{
> +       return sclp_get_stsi_mnest() ?: S390_DEFAULT_MNEST;
> +}
> +
> +static int arch_max_cpus(void)

If arch_topo_lvl is renamed, also rename this function accordingly.

>  static struct {
>         const char *name;
>         void (*func)(void);
>  } tests[] =3D {
>         { "PTF", test_ptf},
> +       { "STSI", test_stsi},

missing space                ^
