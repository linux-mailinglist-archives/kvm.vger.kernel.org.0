Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807472DC341
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 16:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgLPPij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 10:38:39 -0500
Received: from mga14.intel.com ([192.55.52.115]:35416 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgLPPij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 10:38:39 -0500
IronPort-SDR: PYcVpjy7OXvXN+Ic6qBSezLM6XrlYIIb7teRYXgz+c10yMUs+welRC0Ukoc0En0T87cheBQ8lQ
 j+Sj4xgHOXqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="174309732"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="gz'50?scan'50,208,50";a="174309732"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 07:37:58 -0800
IronPort-SDR: SgKS2EdCviSrk3xq56yTrNF57lXIodOk8ngEfWVhisT1w8JTwjQ2JIkEayCgC+/gbdJRDFOmHB
 TsXsjZMjRFIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="gz'50?scan'50,208,50";a="556995633"
Received: from lkp-server02.sh.intel.com (HELO 070e1a605002) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 16 Dec 2020 07:37:56 -0800
Received: from kbuild by 070e1a605002 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kpYsF-000061-GS; Wed, 16 Dec 2020 15:37:55 +0000
Date:   Wed, 16 Dec 2020 23:37:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Uros Bizjak <ubizjak@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] locking/atomic/x86: Introduce arch_try_cmpxchg64()
Message-ID: <202012162318.fXCznDrD-lkp@intel.com>
References: <20201215182805.53913-3-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20201215182805.53913-3-ubizjak@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Uros,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tip/master]
[also build test ERROR on next-20201215]
[cannot apply to tip/x86/core kvm/linux-next v5.10]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Uros-Bizjak/x86-KVM-VMX-Introduce-and-use-try_cmpxchg64/20201216-024049
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git d1c29f5debd4633eb0e9ea1bc00aaad48b077a9b
config: i386-tinyconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/60a11e7e63e120b5fd41b5346cf5a05ea71c7cb2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Uros-Bizjak/x86-KVM-VMX-Introduce-and-use-try_cmpxchg64/20201216-024049
        git checkout 60a11e7e63e120b5fd41b5346cf5a05ea71c7cb2
        # save the attached .config to linux build tree
        make W=1 ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: arch/x86/events/core.o: in function `x86_perf_event_update':
>> core.c:(.text+0x847): undefined reference to `cmpxchg8b_emu'
   ld: kernel/sched/clock.o: in function `sched_clock_local.constprop.0':
>> clock.c:(.text+0x1b4): undefined reference to `cmpxchg8b_emu'
   ld: kernel/sched/clock.o: in function `sched_clock_cpu':
   clock.c:(.text+0x293): undefined reference to `cmpxchg8b_emu'
>> ld: clock.c:(.text+0x2e3): undefined reference to `cmpxchg8b_emu'
   ld: kernel/events/core.o: in function `perf_swevent_set_period':
   core.c:(.text+0x8cbb): undefined reference to `cmpxchg8b_emu'
   ld: fs/inode.o:inode.c:(.text+0x10ca): more undefined references to `cmpxchg8b_emu' follow

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--cWoXeonUoKmBZSoM
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICG0m2l8AAy5jb25maWcAlFxrc9s2s/7eX8FJZ860M0nqS+w3mTP+AIGghIq3EKQu/sJR
ZdrR1Jb8SnKb/PuzC5AiSC7Uns40cbCL+2L32Qv9808/e+ztuHtZHTfr1fPzD++p2lb71bF6
8B43z9X/en7ixUnuCV/mH4E53Gzfvv+2uf586918vLz4eOFNq/22evb4bvu4eXqDrpvd9qef
f+JJHMhxyXk5E5mSSVzmYpHfvXtarz988X7xqz82q6335eP1x4sPlze/mp/eWd2kKsec3/1o
msbtUHdfLq4vLhpC6J/ar65vLvR/p3FCFo9P5LaL1efCmnPCVMlUVI6TPGlntggyDmUsWpLM
vpbzJJu2LaNChn4uI1HmbBSKUiVZ3lLzSSaYD8MECfwBLAq7wnH97I31wT97h+r49toe4ChL
piIu4fxUlFoTxzIvRTwrWQbbkZHM766vYJRmyUmUSpg9Fyr3NgdvuzviwKf9J5yFzQG8e9f2
swklK/KE6Kx3WCoW5ti1bpywmSinIotFWI7vpbVSmzICyhVNCu8jRlMW964eiYvwiSbcq9wH
ymm31nrtffbpetXnGHDtxEHZ6x92Sc6P+OkcGTdCTOiLgBVhroXDupumeZKoPGaRuHv3y3a3
rX617l0t1UymnJxzznI+Kb8WohAknWeJUmUkoiRblizPGZ+QfIUSoRwRy9ZXxDKYhBWgZmAt
IIRh8y7giXmHtz8OPw7H6qV9F2MRi0xy/QLTLBlZj9ImqUkyt4Uh86FVlWpeZkKJ2Kd7IS2b
sRxfQZT4vQcfJBkXfv2WZTxuqSplmRLIpK+82j54u8feDlrVlPCpSgoYyxyxn1gj6eOwWfSd
/qA6z1gofZaLMmQqL/mSh8RZaI00a4+2R9bjiZmIc3WWWEagtZj/e6Fygi9KVFmkuJbe+0sT
JRclTwu9jkxpxdcoTn3L+eal2h+oi57clykMn/iS2+8oTpAi/ZAWSk0mKRM5nuAF10vp8tQ3
NlhNs5g0EyJKcxheW4HToE37LAmLOGfZkpy65rJpevNwML/lq8Of3hHm9VawhsNxdTx4q/V6
97Y9brZP7XHkkk/1STLOE5jLyN9pCpRPfdctmV6KkuTO/8VS9JIzXnhqeFkw37IEmr0k+Gcp
FnCHlCVShtnurpr+9ZK6U1lbnZofXBqliFVtgvkEnquW4kbc1Ppb9fD2XO29x2p1fNtXB91c
z0hQO+9yzuK8HOGbhXGLOGJpmYejMggLNbF3zsdZUqSK1poTwadpImEkEMY8yWg5NmtHS6zH
InkyETJa4EbhFLT/TCuPzKdZkgSUxuAg23XyMklBouS9QMWHbxH+iljMBXHwfW4FP7TXC7Ah
ydIJi+EEs7inIwrpX95aqhRUVR6C4HCRaj2cZ4wP9ApX6RTWFLIcF9VSjbzZdxGBBZRggjL6
mMcij1An1RqSZlqqQJ3lCGBvLo1kdCCldE7aAYRhSl9S4XjF3f3TfRlYpKBwrbgAWE5SRJq4
zkGOYxYGtDzpDTpo2oY4aGoCCIKkMElDJZmURebSb8yfSdh3fVn0gcOEI5Zl0iETU+y4jOi+
ozQ4KwkoaRp1BRRQ01oEfYp2CTBaDCYU9EBHdyrxlegPvYTvC7//HGDO8mTFLSm5vOjASa3r
ar8trfaPu/3LaruuPPFXtQVdz0ALctT2YANb1e4Y3BcgnIYIey5nEZxI0gOStVr9lzO2Y88i
M2GpTZnr3aCvw0AfZ/TbUSEbOQgFhUZVmIzsDWJ/uKdsLBog7ZDfIgjA2KQMGPUZMFDqjoee
BDIcSG59Sl0/sFnV4vNteW25TvBv2xlUeVZwrSZ9wQGwZi0xKfK0yEuttMErqJ4fr68+oAN/
8g/QMPoiLVWRph1vFewnn2q9O6RFUdFDqxHawSz2y5E0QPHu8zk6W9xd3tIMzY3+wzgdts5w
JyyvWOnbfqUZgC0b81EGPieALCDqUYaQ2kfT2uuO7xYBGJrdBUUDBwjAuIxFz/ydOOD2QZrL
dAySkPfesBJ5keJ7MiAPXIyWIRaABRqS1gEwVIagf1LEUwefFkiSzaxHjsCnNK4OmCglR2F/
yapQKbhKLrJGQ/roWFhOCrCk4WgwgpYe1WgLWJJ+Ih15BvkGF+Z+WY6Vq3uhPT2LHIBJFSwL
lxw9NWEhgHRswF8IGiRUd1e9YI5ieD0o33gHgsNbbbBhut+tq8Nht/eOP14NBu6AxHqge3AB
ULhobRDRUA23GQiWF5ko0RWnNdo4Cf1AKtqNzkQOlhmkyzmBEU6ATxltm5BHLHK4UhSTc9ih
vhWZSXqhBp0mkQT9ksF2Sg1oHfZ0sgSRBKsMsHBc9OJSrU3+9PlW0YAESTTh5gwhV3RUA2lR
tCAMQHSrdWvLCcIP0DGSkh7oRD5Pp0+4odLhnmjq2Nj0P472z3Q7zwqV0BITiSCQXCQxTZ3L
mE9kyh0LqcnXNKiLQEU6xh0LMFPjxeUZahk6BIEvM7lwnvdMMn5d0gE7TXScHWIvRy8w5e4H
UlsNQpKQqt9DjLsxdkFNZJDf3dgs4aWbhpgqBRVl/EVVRF2VCdLdbeBRuuCT8e2nfnMy67aA
XZVREWllEbBIhsu7W5uuNTV4YJGysIRkoA1Qf5VA6cY/Ei4UPm0lQtCmlGsIE4Ei1wdiRaCa
Zn2nHYjTUFjkDxsny3ESE6PAa2JFNiQAiolVJHJGTlFEnGy/n7BkIWN7p5NU5MbJIQXCjySx
91ibYlXCIsAYj8QYxrykiRiTHJBq4DkgQENHFPG0UkkrPH3pXafdmDsLjr/stpvjbm8CTu3l
tsgfLwOU/Ly/+xq7OsbqLiIUY8aXAO4dWlu/miQN8Q/hMEx5Am9lRNte+Zl2BHDcTGC8A1CD
KywTSQ6iDM/VfYaKvvna8krK34sTjDoafNIJRELTJ9qBram3n6j41ixSaQhG97oT+2tbMQhD
jtqwXNGTtuR/HOGSWpfGmkkQAIi9u/jOL+pkXOeMUkYFjjTOCwCLwJ7hDTACherYupus9U6T
hsCgvaVkZIhCFzbwBEPmhbjrLUxrWPAmEoVueFbosJNDq5sEAVioZH53+8kSnzyjpUOvEV64
f8aQKHBsnEQAGOkZExOCKVjobeP521JBcdA2meDspwBb8bwvLy8uqNDrfXl1c9GR8/vyusva
G4Ue5g6GsYIxYiEoE5tOlkqCv4ZYPkOhu+zLHLhp6IujyJzrDy7fOIb+V73utZM58xV9EDzy
tasHeoVG23COMliWoZ/TAaNGdZ7xOoye3v1d7T3Qraun6qXaHjUL46n0dq+Yc+84J7XLRocf
Itf7O/lZOKx9hXoa0gEIOu1NNsML9tV/36rt+od3WK+ee/ZEQ46sG9iyExBE79PA8uG56o81
TAJZY5kOp1P+x0PUg4/eDk2D90vKpVcd1x9/tefFyMKoUMRJ1jEHNMSdxIxyeIocRY4kJaEj
IwuySiPjWOQ3Nxc0ptYaZqmCEXlUjh2b09hsV/sfnnh5e141ktZ9HRo7tWMN+LuZXgDTGJtJ
QN01Pnew2b/8vdpXnr/f/GXCjm3U2KflOJBZNGfgSIPOd2nOcZKMQ3FiHchqXj3tV95jM/uD
nt1OBTkYGvJg3d2yg1nH4M9klhdwd/fMYVmwyGS2uLm0kCiGKibssoxlv+3q5rbfmqcM/IV+
Qclqv/62OVZr1CUfHqpXWDpKfqs1mrOqo1+A8zIr5qV3kpiYpWV0m5YyjqTBw/ZWfy+itAzZ
SDgyCDkcgY6zhWi4A0eZip5au6cSo8BFrJU05sM4ehs9BICuEtam5DIuR2rO+jUoEvw7DB0S
QbdpP65kWjHUQhEAG9EdTCsW6wRUuiooYhOkFVkGrpKMfxf63z02ONFei96fHnGSJNMeEZUN
/DuX4yIpiPS9gqtAFVkXLFDxSFD6aKNMQQHBAHiuRlYOoi8zjb4Gh25WbqqeTJC6nE8kYAxp
VxCc4ojg6ixjhupBVwiYHj2+66sR4E9AOWX/GrFCC8xtXb/Uv51MjOF9xb4J+9UyVKvpDp8S
X10Xh9VWzo6TeTmCjZqsbo8WyQXIbUtWejn9FCiASozvFVkMLgNcibQD+f0UDyEnWN+C0Xzw
A31hopq6BzUIMX+TxcnqI/KLiLzP9nWfp+oQeS5nQ5EyUl4qFogmZNEbqm41FWkOmp8UjnC0
THlpanGaKjdioUpwtF9nSHWkvpMOMhSXtjK98fRCuOp+bL8fb7YVokU5O/hc5hPQcOaGdNS1
f41EDUhfGhO87aifP2zUTIy+FmpcjOajT0cdMdJwDLRFWV/TwStsvDbBQY6tKBWQihCUJKpr
UP0oI4RS0RTtLnVSKO0yO9mkHoNYgIIgtV231ymvxEMM5o/gRAEl+NZwCVY6ynENp68HBNbo
776/YJQU3sK59C/oNwkasa7qy+ZWOukMqd/dnGiXpz2oFA74+qpxg7p60c5Dg93n2TId5KNa
U01JwaCkw0APnsw+/LE6VA/enybp+7rfPW6eO5VMp8mRu2zghJmnzYaeGamzTiwPTsNiLGPV
6f/vQFAzlC6WUJjDtkNrtchSuYJamPNMYDAgAc1rC8MIlTHlI8QmPZjCQy5iZKprBrt0bTUN
/RyN7DvPwMq6OtvEbu+eH2igOoBnAmvpilBfb0JXI7pZsjnFgFcfg00FXZSFLIVhsGzDz9C4
ggKigUhTJFGORIB/obXqVmhavNrbhs3C4OKU3hPfq/XbcfXHc6Ur3D0dsDx2PI6RjIMoRx1E
134YsuKZdATJao5IOpJPuAM0rqQr5lqgXmFUvezAt4paD3aA489GwpoQW8TignVC+G18zdAI
sa07d0crdXLD9LNsaTuc0SB9RIW1quOi0wHDimmuZVIHtz/1tCrvu01tSAPjjplAoe2VVViu
V5kn6LLbe54qKhbS1EtrY2EKXv3s7tPFl1srAE1YSSrwa2fipx1vkANAiHXexxFXouMF96kr
0HQ/KmhH+V4Ni3L6Ph/m0BsPqZPYEZlOhsAdOnLVgDVHYDomEcsoVXd6jmkuDBqw4dwUj7iB
eKcX4BbyTqjD6TFicdbvulxavxm/+muztkMLHWapmL1h0QvUdPAx74R0MExCSiPnrFtt2frj
m3W9Di8ZRu0KU+00EWHqSi+JWR6lgSMbnwNgYghlHGVHZvhT3ER/yDFY5imk8bxbPdTBkOa5
z+GumO9I/vQ72vGqMJnrQlRa8Z02h8UhfgYOg2v3mkHMMkfhhGHAaEI9DCgFxLpnJF9X2RR5
4viGAMmzIsTilpEEBSXFEF4M7/QURHzQote55Ggi+5HDThSu6WI9sVg5klU5/eCTwPUQIzme
5KfiJ9BfdVGXpUl100Aq4hkgWfX2+rrbH+34WKfdWKjNYU3tG649WiLYIJcMGiRMFJbFYGJF
cscFK/B36OgmFtQtSuUHwmFyr8h9CQEXH3kHa2fNijSl/HLNF7fkZfW61vHE76uDJ7eH4/7t
RZc2Hr7Bk3jwjvvV9oB8HkDXynuAQ9q84o/dYOP/u7fuzp6PAHK9IB0zK1S5+3uLL9F72WEt
u/cLBtU3+womuOKdWLbgk4TcYecquy6mfwozKq5kzWQdY3NfQEQIYr8ZqoMl04zLGNO79QtW
gyuT29e343DGNtIep8Xwoier/YM+F/lb4mGXbr4EvzD5d49Gs9pPZgwueF+2Tpulpj19F0Rt
xKwKrn21hkulHlKe08X+uDAWajU70C/N0aSRLE2NuqNGa34uSZnyz/+5vv1ejlNHSXasuJsI
C3OVeANp6qLFM9ebh42MTdLWXY+Rc/g/dRQRiJD3HbQ2dzS4grajOSLAgAUYGiwoGFpFI6lX
nBTQK7o+2ma3uK9phaZcKbk0ogmT/ic/za2mwzeW5qm3ft6t/7TWb/TlVjsm6WSJ3/Jh9gyA
GH7IhZlUfQ+AQiL05bzjDsarvOO3yls9PGzQMoIjrkc9fLTV3nAya3EydtYxoqT1vig80eZ0
EkyXrujsPe24GTr6vyH9yCbzyOGD5BPwRBm90ub7PkLDKDWyC2vba1RUcfoI3AKSfdTzF4wp
fns+bh7ftms8+0bRPAwzbFHgg94FCaZdjkmOUEFJfk2jEOg9FVEaOmoAcfD89vqLo+wOyCpy
JS3ZaHFzcaFho7s3+Pmu6kUg57Jk0fX1zQKL5ZjvqAZFxq/Rol+S1BjCcwdp6QUxLkJn2X8k
fMlKLngTXznDRXAYH2K/ev22WR8oteJ3a6UMMoA224TU+7GbDejfr14q74+3x0dQeP7Q5jiy
xmQ3A35X6z+fN0/fjt7/eCH3z5hroOJn+gqr3BD40QEVDKhrM+xmbTD0P8x8gu79o7TeXlLE
VBlXAW81mXBZgiOQh7pWT7JO9Bc5zt5u5JA/ESn8stOR1Qe/S/i0STfZKKmdkyWxZuEz3sTx
FM8KqzRfkwYfdmTw2kGrdhsifvnp9vPl55rSSnzOzY3QZh2VygDMG588YqMiIEtXMMSHoWDX
kNDPJDB0ioxW0zXbRLB+nV99+735rfMsFr5UqeuLysIBbnSAiUCsHQaZwEXHBU33U1r7zvCz
/UG/2tVa73eH3ePRm/x4rfYfZt7TW3U4dl7ZCcqfZ+1EEcaur+p0/V79wUBJXG3rbU3ANRIn
Xtf3d2HI4mRx/hsEnkRgckHK6McxmTcB6MHxcI0p1O5t3zF7p/jbVGW8lJ+vbqy8DrSKWU60
jkL/1NqCRGoG25eR4SihS3UkbKtw6vmsetkdq9f9bk3Zawxq5Oh90jiS6GwGfX05PJHjpZFq
JJQesdPTuH0w+S9Kf5PtJVuAy5vXX73Da7XePJ7iIYcGNbKX590TNKsd78zfmCOCbPrBgOD+
uroNqcb27MHtXe9eXP1IuolyLNLfgn1VYdlZ5X3d7eVX1yD/xKp5Nx+jhWuAAU0Tv76tnmFp
zrWTdNty4a96GIjTAhNm3wdjdmMnM16Ql091Pvny/0oKLHyt1caw+K+xSIvcCeV0OoN+Sg6d
nM6HgAjjT2tYJaUjBzTbccZsu8ut1v6ErsHJkjAkHEHwjTq/LaF1YeowIzKQuIdH5TSJGQKL
KycXul7pgpVXn+MI3TwaY3S4cDwnlykCDsdRKQaApfHZOjvqOVDcUY0X8dHwaIafDFB3c47N
dsyHSINtH/a7zYN96uC+Z4n0yY017BaWYI5iy344w8SZ5hitW2+2TxTYVTlt5Oqy6wm5JGJI
C5lj0I+Objh+o4R0WCQVysgZOMKyefg57n3bY1npYvjhX4O1uvmXOssAWtNIj2WTffMd1DzJ
rBq/Fgk1v+gmUKa4h/azxAJNKvDo7HuZOL700NUGyOECOzBCXRLhSjsCB+A96YjH+WfwqTS0
0vkLKQJ2pvfXIsnpS8dMRqA+lY4MkSG7qAGm7B00k6Rf9shGtFfrbz1vURF5zQYyGW7z9g/V
28NOZ7lbUWhVCeAb13I0jU9k6GeCvhv9yzpoxGg+UXZQzV/EITWKaLhmS8FJZXwXmD0XDtgb
O34dRRHL4YdHp9ya9VwM/qrWb/vN8QflQk3F0pE+EbxAeQX/SChtt3QF0Vlel7B0akbpEUzp
UFOiMUxrNg+lzre3q2NWuUCoort3z6vtA2Lt9/gHZjbe/1i9rN5jfuN1s31/WD1WMODm4f1m
e6ye8Fze/19lV9PbuA1E7/0VQU89bItkN9jupQdZthzB+oooRU0vhpO4rpEmMeykWPTXlzOk
KHI0o6SnzWpGFEVSwyH53vPd4c8fA6WLvzbHh+0zRNGhyXxMxV7PKvvN3/t/iYQhSu0ZuB2V
fUITwELheN29hxAteucEsEKSb3gCTqtElDSYN3KJGR0e3giHkFaOPuNsf3cE2P7x5e11/xx+
0JD98MAKBzJu6iKudHyAMzPocQaHrF2yRSFYk7To1QxmaXAkGevZQEppaoA5Fm0+I8tuml7F
qeMbEBO5PGCiAaCCokFVFsBwHbhJ3eY6k9Bh2qHqvCbW0SlOG2GurOMLnvoI9zUX5/OUBx6B
OW3atVjsFz6n05avPMFcW0QDv1+bpTN8kHDKWsc8A90cmXz5zML9h5XIH6BfwnQk9IjuKR97
ZC7BVE9h5yrU/EAMjsI9obUef8sm0OiyVB0DHeC/W1AYJFpI7lmAPLQjCShi4/Gl5xo4FSmT
uS8k4t8TMI8DA4J4R3hNDEVdlK1CADFIIQmta2PC6AsPo+P9o4Fn4tXDUUfSRzzgeXjannZj
mJn+R5WYQi1RY8ORlH8VPa7bdNH8dunAkzq/A+DWqIRLfxrPZ2UGCKW6BsEM9sXEypoY9vJ0
0NPnz6hop5OP+8cTut6b60duBjVAEpBp5VNMZKDq8ICiKgsW42kEMRAVe3H++TLsqgq5CqK6
FIA78QmREo4+F3Bco1D5J2KHpnkDZQgmkJjkcAblwe2IBWuqp6PsNvg6sBQUvPRIEMDCAYQz
n/Z6t3SLaNXD3/hs8KN9EyCo7JCdb+/edjuY/jzIRHCuFS1h3rlVAujEVpWbOQb89Go5D7a8
4f/MDW7iaGcqKkBfJm1ABa/HM/dJHljZpvjQy4W9a8Dh4/6iuFM/y3HlhvM7KA+AJIyS1jpE
uYefjpH+3RXCmgbNVZmqspDWXOYpdamXeZEkXuxa2jgj6p0U0HG6Li4ZaCyvhdxUzoCOJQ4G
2+R6DrLMDnJ7b5l4L5NEtopgRYfIgHI6xgsEl6TQQlrgJu/Vjsa1upEAF+GNH3iIIS8yTzCG
icdYJDLkvxNeAxRUqoyDpQ+uNs4Q0CotcPCa7lxseVjpJhmqBnPd15uZkqy01CqCAGBHm3eG
YKyAlYCZuiiHEGFA7wwCdvhYR3W5Ikg6i3TV/mfly+H06SzTK6W3gwmnV5vnHUno9WITFiMl
2R7h7E4uITBiVtM2voqCKpOG0M/42WtMUxMGBhj1gl23F/ABWafumoVXeLtPU23yQ6gGG0bH
kRys3B/QGqvFoiKBzays4JBoiOc/nfSSFVEwn86e3l6337f6D6Bb/4IU8z7Phr0rLHuJiZ07
pvX3QG6md7CwDFiFT8Uk5vSMfr+gETqJuO064wTiiV0V0X3MMLh3StoZMQ5Ya3mSMU79iXam
2/ydspBXojP8Pjfmn41P1QMRpdnEBcrwolPLGBUnE0X12fj/GBXBnoqVZOTrB0kckF7aQull
D3BvZDifDZNm3hNiiSVdPWxeN2eQhtyPdPBsQ6dCW9i84R27mkoHeiqsoMQKU3exxoyB120h
oUB4JfrUuNbtVzRplI23PEGSmk2kQOsaWEcTQwhc3h1n4FQvkg+VJQ4GFN6+VtzS1pPWlmNa
Z6Xu1/Uoge+zWccVFlRCQ/Y0OlFGs7Mu66i64n16UjjLqg+NyI/lyM2cm6Wto0QwrZZxy/Fg
Q5cHu1CUGmkJZuhpWN2UqGxvNKUMRrhDiOqJ3J8qyiuehujlanAoBb+dgpwLVAjG8fn929dg
xHoVQcJwkkVLNe4/YkfO9rjOAAvRadGsVKiD0wg65YZkNCFzbafSbIZK6lKuludpSYdbUBUr
gTulLJGWRtp1ff77t0CsyDMseDyj82jnou668ykkMk5cRRNbTqYhUIiD3yfrBfrWCV1Y919m
0aUFNIKoy0kdQZMzyEHDIePvFTXbE/wSAKZR8cs/2+NmF4jyrFop1e9DOVXAEM7AzI+ZMD5h
Tq0zaaAQm0FRBT8TUQP/PTchFL44EX+lPxtxqp587dGevNlH+w+A59ndWmkAAA==

--cWoXeonUoKmBZSoM--
