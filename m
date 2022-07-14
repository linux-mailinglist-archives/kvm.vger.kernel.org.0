Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2D5575138
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiGNO6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 10:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239574AbiGNO6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 10:58:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894515C9E0
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 07:58:06 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EDsJ6t007767;
        Thu, 14 Jul 2022 14:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uybCWJGQKRNmU0OAnHjQ5WuN8GG3V5NcHeMnPksEyc4=;
 b=nPih358fyOC2gOtSJ1twRji55XJFmuBTjK+G895ahTf7FAA1vSCvv/MvwP7B8w+4PCBd
 N5p8qD5NDzGK4KEfIS2SVqqFmRrWlZPV55piMPacs6jTw2xu074xRNPkIediuWEiuzSK
 1LZgqTCmdutiP6C0H7dk0HPTSeNN6bAVXUZYArUUAx+ZNncMjYg047qZhYtbQKwtXYuw
 8FHDGZEkbXyOpJvRk5UdZnIDo13Nu7uRGRGGpzmnL41MVhcs+20tK9mttRutGURcjqHX
 EDzlv8jWv73j/CD1da3WLGJ/R25jqpdxI6q+/UiipUv4y7XQuQOb72U8LT+eQNdnRw5h bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hame89n7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 14:58:01 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26EEw1fM006685;
        Thu, 14 Jul 2022 14:58:01 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hame89n6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 14:58:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26EEoLqh023074;
        Thu, 14 Jul 2022 14:57:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3h70xhy8eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 14:57:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26EEw6jV26870250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 14:58:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2483BA4040;
        Thu, 14 Jul 2022 14:57:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD097A4051;
        Thu, 14 Jul 2022 14:57:46 +0000 (GMT)
Received: from [9.171.84.216] (unknown [9.171.84.216])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 14:57:46 +0000 (GMT)
Message-ID: <3a821cd1-b8a0-e737-5279-8ef55e58a77f@linux.ibm.com>
Date:   Thu, 14 Jul 2022 16:57:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v8 08/12] s390x/cpu_topology: implementing numa for the
 s390x topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-9-pmorel@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220620140352.39398-9-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ep_XZITM-z0Mg8GeoK2FTcAVaFBG4uDq
X-Proofpoint-ORIG-GUID: D6hF0RvvpIEj6j5ZvKUMfMK-tH1tU32k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_10,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 16:03, Pierre Morel wrote:
> S390x CPU Topology allows a non uniform repartition of the CPU
> inside the topology containers, sockets, books and drawers.
> 
> We use numa to place the CPU inside the right topology container
> and report the non uniform topology to the guest.
> 
> Note that s390x needs CPU0 to belong to the topology and consequently
> all topology must include CPU0.
> 
> We accept a partial QEMU numa definition, in that case undefined CPUs
> are added to free slots in the topology starting with slot 0 and going
> up.

I don't understand why doing it this way, via numa, makes sense for us.
We report the topology to the guest via STSI, which tells the guest
what the topology "tree" looks like. We don't report any numa distances to the guest.
The natural way to specify where a cpu is added to the vm, seems to me to be
by specify the socket, book, ... IDs when doing a device_add or via -device on 
the command line.

[...]
